--Card-Mistress Energy
function c249000595.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000595.target)
	e1:SetOperation(c249000595.activate)
	c:RegisterEffect(e1)
end
function c249000595.filter(c)
	return c:IsSetCard(0x1D4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c249000595.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000595.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c249000595.filter2(c)
	return c:IsSetCard(0x1D4) and c:IsType(TYPE_MONSTER)
end
function c249000595.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000595.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)	and Duel.IsExistingMatchingCard(c249000595.filter2,tp,LOCATION_HAND,0,1,g:GetFirst())
			and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,501) then
			local g2=Duel.SelectMatchingCard(tp,c249000595.filter2,tp,LOCATION_HAND,0,1,1,g:GetFirst())
			Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end
