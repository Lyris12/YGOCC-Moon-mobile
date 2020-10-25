--.LiveVTuber Yamato Iori
function c33701110.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3)
	c:EnableReviveLimit()   
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701110,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetLabelObject(c)
	e2:SetCondition(c33701110.xyzcon)
	e2:SetOperation(c33701110.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c33701110.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)	 
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c33701110.spcost)
	e4:SetTarget(c33701110.sptg)
	e4:SetOperation(c33701110.spop)
	c:RegisterEffect(e4)
	--re
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c33701110.recost)
	e5:SetTarget(c33701110.retg)
	e5:SetOperation(c33701110.reop)
	c:RegisterEffect(e5)
end
function c33701110.mattg(e,c)
	return c:IsSetCard(0x1445) and c:IsType(TYPE_XYZ) and c:IsRank(12,10)
end
function c33701110.xyzcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local xc=e:GetLabelObject()
	return Duel.GetLocationCountFromEx(tp,tp,xc,e:GetHandler())>0 and xc:IsCanBeXyzMaterial(nil)
end
function c33701110.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local xc=e:GetLabelObject()
	local mg=xc:GetOverlayGroup()
	if mg:GetCount()~=0 then
	Duel.Overlay(e:GetHandler(),mg)
	end
	e:GetHandler():SetMaterial(Group.FromCards(xc))
	Duel.Overlay(e:GetHandler(),Group.FromCards(xc))
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c33701110.splimit)
	Duel.RegisterEffect(e3,tp)
end
function c33701110.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c33701110.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33701110.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33701110,nil,0x4011,2000,2000,11,RACE_CYBERSE,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c33701110.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,33701113,nil,0x4011,2000,2000,11,RACE_CYBERSE,ATTRIBUTE_WATER) then
		local token1=Duel.CreateToken(tp,33701113)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetLabelObject(c)
		e1:SetValue(c33701110.atkval)
		token1:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetLabelObject(c)
		e1:SetValue(c33701110.atkval1)
		token1:RegisterEffect(e1)
		--cannot release
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(1)
		token1:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token1:RegisterEffect(e5)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetLabelObject(c)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c33701110.atxx)
		token1:RegisterEffect(e2)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetLabelObject(c)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c33701110.atra)
		token1:RegisterEffect(e2)
		--
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token1:RegisterEffect(e6)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token1:RegisterEffect(e6)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token1:RegisterEffect(e6)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token1:RegisterEffect(e6)
		local token2=Duel.CreateToken(tp,33701113)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetLabelObject(c)
		e1:SetValue(c33701110.atkval)
		token2:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetLabelObject(c)
		e1:SetValue(c33701110.atkval1)
		token1:RegisterEffect(e1)
		--cannot release
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(1)
		token2:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token2:RegisterEffect(e5)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetLabelObject(c)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c33701110.atxx)
		token2:RegisterEffect(e2)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetLabelObject(c)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c33701110.atra)
		token2:RegisterEffect(e2)
		--
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token2:RegisterEffect(e6)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token2:RegisterEffect(e6)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token2:RegisterEffect(e6)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token2:RegisterEffect(e6)
		Duel.SpecialSummonComplete()
	end
end
function c33701110.atkval(e,c)
	return e:GetLabelObject():GetAttack()
end
function c33701110.atkval1(e,c)
	return e:GetLabelObject():GetDefense()
end
function c33701110.atxx(e,c)
	return e:GetLabelObject():GetAttribute()
end
function c33701110.atra(e,c)
	return e:GetLabelObject():GetRace()
end
function c33701110.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,33701113) end
	local tc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,33701113):GetFirst()
	Duel.Release(tc,REASON_COST+REASON_RULE)
	e:SetLabel(tc:GetAttack())
end
function c33701110.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c33701110.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end










