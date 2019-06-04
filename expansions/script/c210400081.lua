--created & coded by Lyris, art by Sinad Jaruartjanapat
--天剣主女王十
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xbb2),2,2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cid.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler() local rc=re:GetHandler() if c:GetFlagEffect(id)==0 and re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0xbb2) and c:GetLinkedGroup():IsContains(rc) then c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1) end end)
	c:RegisterEffect(e3)
end
function cid.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function cid.val(e)
	return Duel.GetMatchingGroupCount(cid.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*100
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0xbb2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or ((Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp))))
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if c:GetFlagEffect(id)==0 or g:GetCount()==0
		or not Duel.SelectEffectYesNo(tp,c) then
		c:ResetFlagEffect(id)
		e:SetCountLimit(e:GetCountLimit()+1)
		return
	end
	c:ResetFlagEffect(id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
		else return end
		Duel.Hint(HINT_CARD,0,id)
		local p=tp
		if op~=0 then p=1-p end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,p,false,false,POS_FACEUP_DEFENSE)
	end
end
