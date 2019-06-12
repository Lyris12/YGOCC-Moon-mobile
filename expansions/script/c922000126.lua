--Orcadragon's Swim
local m=922000126
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--(1) You can only activate this card if you control "Orcadragon - Penelope" or "Orcadragon - Ascended Penelope". When this card is activated: add 1 "Orcadragon" card from your deck to your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.actcon)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	--(2) All monsters you control become WATER monsters.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
	--(3) While you control a WATER monster: neither player can declare attacks against WATER monsters, also all other cards on the field have their effects negated.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	e3:SetCondition(cm.negcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetValue(cm.atlimit)
	c:RegisterEffect(e5)
end
--(1)
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function cm.cfilter(c,e,tp)
	return c:IsCode(id-8) or c:IsCode(id-14)
end
function cm.thfilter(c)
	return c:IsSetCard(0x904) and c:IsAbleToHand()
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,sg)
	end
end
--(3)
function cm.negfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.negcon(e)
	return Duel.IsExistingMatchingCard(cm.negfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.atlimit(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
