--KILLER FACELESS
function c18591842.initial_effect(c)
    --Link summon
    aux.AddLinkProcedure(c,c18591842.matfilter,3)
    c:EnableReviveLimit()
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591842,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCondition(c18591842.condition)
    e1:SetTarget(c18591842.target)
    e1:SetOperation(c18591842.operation)
    c:RegisterEffect(e1)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18591842,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCondition(c18591842.discon)
    e2:SetCost(c18591842.discost)
    e2:SetTarget(c18591842.distg)
    e2:SetOperation(c18591842.disop)
    c:RegisterEffect(e2)
end
function c18591842.matfilter(c)
    return c:IsSetCard(0x50e)
end
function c18591842.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c18591842.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local dam=bc:GetAttack()
    if dam<0 then dam=0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam)
end
function c18591842.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function c18591842.discon(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not tg or tg:GetCount()~=1 or not tg:GetFirst():IsSetCard(0x50e) then return false end
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c18591842.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function c18591842.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c18591842.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end