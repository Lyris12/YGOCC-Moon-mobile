--created & coded by Lyris
--フェイト・ヒーローディサイズガイ
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r) return r==REASON_FUSION end)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf7a)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
