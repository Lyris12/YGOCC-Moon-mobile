--SC2 Unit - Siege Tank
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c115000264.initial_effect(c)
	--destroy
	Senya.AddSummonSE(c,aux.Stringid(115000264,0))
	Senya.AddAttackSE(c,aux.Stringid(115000264,1))
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c115000264.condition)
	e1:SetTarget(c115000264.target)
	e1:SetOperation(c115000264.operation)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(c115000264.ccon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e3:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c115000264.spcon)
	c:RegisterEffect(e3)
end
function c115000264.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsDisabled() and e:GetHandler():IsDefensePos()
end
function c115000264.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c115000264.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(c115000264.filtere,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c115000264.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c115000264.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c115000264.atkfilter(c)
	return c:GetCode()~=115000264
end
function c115000264.ccon(e)
	return Duel.IsExistingMatchingCard(c115000264.atkfilter,tp,LOCATION_MZONE,0,1,c)
end
function c115000264.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1AB)
end
function c115000264.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c115000264.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end