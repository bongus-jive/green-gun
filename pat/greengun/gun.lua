require "/items/active/weapons/ranged/gunfire.lua"

GreenGun = GunFire:new()
function GreenGun:init()
	GunFire.init(self)
	self.cooldownTimer = 0
	self:setState(self.cooldown, "equip")
end

function GreenGun:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)

  if animator.animationState("firing") ~= "fire" then
    animator.setLightActive("muzzleFlash", false)
  end
	
  if self.fireMode == (self.activatingFireMode or self.abilitySlot)
	and self.cooldownTimer == 0
	and not self.weapon.currentAbility
	and not world.lineTileCollision(mcontroller.position(), self:firePosition()) then
		self:setState(self.fire)
  end
end

function GreenGun:fire()
  self:fireProjectile()
  self:muzzleFlash()
  self.cooldownTimer = self.fireTime
  self:setState(self.cooldown)
end

function GreenGun:cooldown(a, b)
	local f = util.interpolateSigmoid
	local stance1 = self.stances[a or "cooldown"]
	local stance2 = self.stances[b or "idle"]
	local pos1 = stance1.weaponOffset or {0,0}
	local pos2 = stance2.weaponOffset or {0,0}
	
  self.weapon:setStance(stance1)
  self.weapon:updateAim()
	
	if stance1.hold then util.wait(stance1.hold) end

  local p = 0
  util.wait(stance1.duration, function()
    self.weapon.weaponOffset = {f(p, pos1[1], pos2[1]), f(p, pos1[2], pos2[2])}
    self.weapon.relativeWeaponRotation = util.toRadians(f(p, stance1.weaponRotation, stance2.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(f(p, stance1.armRotation, stance2.armRotation))
    p = math.min(1, p + self.dt / stance1.duration)
  end)
end

function GreenGun:damagePerShot() return 0 end