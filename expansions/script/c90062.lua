--"Hacker - Algorithm, The Persistent"
local m=90062
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Pendulum Attribute"
    aux.EnablePendulumAttribute(c)
    --"ATK UP"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
    e1:SetValue(c90062.val)
    c:RegisterEffect(e1)
    --"Damage"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c90062.damcon1)
    e2:SetOperation(c90062.damop1)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCondition(c90062.regcon)
    e3:SetOperation(c90062.regop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_CHAIN_SOLVED)
    e4:SetRange(LOCATION_PZONE)
    e4:SetCondition(c90062.damcon2)
    e4:SetOperation(c90062.damop2)
    c:RegisterEffect(e4)
end
function c90062.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x1aa) 
end
function c90062.val(e,c)
    return Duel.GetMatchingGroupCount(c90062.filter,c:GetControler(),LOCATION_MZONE,0,nil)*800
end
function c90062.damcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
        and (not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c90062.damop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,90062)
    local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
    Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
function c90062.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
        and re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c90062.regop(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
    e:GetHandler():RegisterFlagEffect(35199657,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function c90062.damcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(35199657)>0
end
function c90062.damop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,90062)
    local labels={e:GetHandler():GetFlagEffectLabel(35199657)}
    local ct=0
    for i=1,#labels do ct=ct+labels[i] end
    e:GetHandler():ResetFlagEffect(35199657)
    Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end