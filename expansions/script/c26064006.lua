--Over-wind Astrarium
function c26064006.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26064006,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c26064006.target)
    e1:SetOperation(c26064006.activate)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_DRAW)
    e2:SetCost(c26064006.spcost)
    e2:SetTarget(c26064006.sptg)
    e2:SetOperation(c26064006.spop)
    c:RegisterEffect(e2)
end
function c26064006.setfilter(c)
    return c:IsCanTurnSet()
end
function c26064006.filter(c,e,tp,mg)
    if not c:IsType(TYPE_FLIP) or not c:IsType(TYPE_RITUAL)
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c26064006.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(c26064006.setfilter,tp,LOCATION_ONFIELD,0,nil,c)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>0 and Duel.IsExistingMatchingCard(c26064006.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26064006.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local mg=Duel.GetMatchingGroup(c26064006.setfilter,tp,LOCATION_ONFIELD,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c26064006.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        local mat=nil
        if ft>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            tc:SetMaterial(mat)
            Duel.ChangePosition(mat,POS_FACEDOWN_DEFENSE)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
            Duel.ConfirmCards(1-tp,tc)
            tc:CompleteProcedure()
        end
    end
end
function c26064006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064006.spfilter(c,e,tp)
    return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26064006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c83764718.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c26064006.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    local g=Duel.SelectTarget(tp,c26064006.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26064006.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE+POS_FACEDOWN_DEFENSE)
        Duel.ConfirmCards(1-tp,tc)
    end
end
function c26064006.spfilter(c,e,sp)
    return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end