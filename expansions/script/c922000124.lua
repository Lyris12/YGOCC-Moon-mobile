--Orcadragon's Pure Freedom
local m=922000124
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--(1) When a card or effect is activated: Special Summon, "Orcadragon - Kura" or "Orcadragon - Ascended Kura" from your hand or GY and if you do: negate the activation and destroy that card, then, the summoned monsters gains 200 ATK for each "Orcadragon" card in the GY. After this effect activation, if "Orcadragon - Ascended Kura" is Special Summoned by this effect: set this card face down instead of sending it to the GY (This card cannot be activated the turn this effect is activated.)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.negcon)
	--e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
end
--(1)
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
		and Duel.IsChainNegatable(ev)
end
function cm.cfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x904) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.NegateActivation(ev)
	Duel.BreakEffect()
	if Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
		local tc=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=Duel.GetFirstTarget()
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.SpecialSummonComplete()
		end
		if tc:GetCode()==id-8 or tc:GetCode()==id-14 then
			e:GetHandler():CancelToGrave()
			Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)
			e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e:GetHandler():RegisterEffect(e1)
		end
	end
end