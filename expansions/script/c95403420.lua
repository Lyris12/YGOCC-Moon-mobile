--Duston Party Parlor
local cid,id=GetID()
function cid.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--direct attack
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_DIRECT_ATTACK)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(cid.target)
	e9:SetValue(aux.tgoval)
	c:RegisterEffect(e9)
	--cannot use
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x80))
	e1:SetValue(cid.limit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_BIGBANG_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_EVOLUTE_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_TIMELEAP_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SPACE_MATERIAL)
	c:RegisterEffect(e8)
	--half damage
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_FZONE)
	e10:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e10:SetTargetRange(LOCATION_MZONE,0)
	e10:SetTarget(cid.rdtg)
	e10:SetValue(HALF_DAMAGE)
	c:RegisterEffect(e10)
	--indes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e11:SetCondition(cid.indcon)
	e11:SetValue(1)
	c:RegisterEffect(e11)
end
function cid.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x80)
end
function cid.indcon(e)
	return Duel.IsExistingMatchingCard(cid.cfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cid.rdtg(e,c)
	return c:IsSetCard(0x80)
end
function cid.target(e,c)
	return c:IsSetCard(0x80) and c:IsFaceup() 
end
function cid.limit(e,c)
	if not c then return false end
	return c:IsLocation(LOCATION_EXTRA)
end