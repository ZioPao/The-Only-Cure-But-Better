local function cureInfection(bodyDamage)
    bodyDamage:setInfected(false);
    bodyDamage:setInfectionMortalityDuration(-1);
    bodyDamage:setInfectionTime(-1);
    bodyDamage:setInfectionLevel(0);
    local bodyParts = bodyDamage:getBodyParts();
    for i=bodyParts:size()-1, 0, -1  do
        local bodyPart = bodyParts:get(i);
        bodyPart:SetInfected(false);
    end
end

function CutArm(partName, surgeonFact, useBandage, bandageAlcool, usePainkiller, painkillerCount)
    local player = getPlayer();
    local modData = player:getModData().TOC;
    local bodyPart = player:getBodyDamage():getBodyPart(TOC_getBodyPart(partName));

    --Set dommage of bodypart & stress & endu
    local stats = player:getStats();
    bodyPart:AddDamage(100 - surgeonFact);
    bodyPart:setAdditionalPain(100 - surgeonFact);
    bodyPart:setBleeding(true);
    bodyPart:setBleedingTime(100 - surgeonFact);
    bodyPart:setDeepWounded(true)
    bodyPart:setDeepWoundTime(100 - surgeonFact);
    stats:setEndurance(0 + surgeonFact);
    stats:setStress(100 - surgeonFact);


    --TODO this is broken
    -- Bandage
    --if useBandage and bandageAlcool then
    --    bodyPart:setBandaged(true, 10, true, bandage:getType());
    --elseif useBandage and not bandageAlcool then
    --    bodyPart:setBandaged(true, 10, false, bandage:getType());
    --end

    -- Painkiller
    if usePainkiller then
        for _ = 1,painkillerCount+1 do
            player:getBodyDamage():JustTookPill(painkiller);
        end
        if painkillerCount < 10 then addSound(player, player:getX(), player:getY(), player:getZ(), 50-painkillerCount*5, 50-painkillerCount*5) end
    else
        addSound(player, player:getX(), player:getY(), player:getZ(), 50, 50)
    end

    -- Change modData
    if bodyPart:getType() == BodyPartType.Hand_R then
        modData.RightHand.IsCut = true;
        modData.RightHand.ToDisplay = true;
        modData.RightHand.CicaTimeLeft = 1700 - surgeonFact * 50;
    elseif bodyPart:getType() == BodyPartType.ForeArm_R then
        modData.RightForearm.IsCut = true; modData.RightHand.IsCut = true;
        modData.RightForearm.ToDisplay = true; modData.RightHand.ToDisplay = false;
        modData.RightHand.IsBurn = false;
        modData.RightForearm.CicaTimeLeft = 1800 - surgeonFact * 50; modData.RightHand.CicaTimeLeft = 1800 - surgeonFact * 50;
    elseif bodyPart:getType() == BodyPartType.UpperArm_R then
        modData.RightArm.IsCut = true; modData.RightForearm.IsCut = true; modData.RightHand.IsCut = true;
        modData.RightArm.ToDisplay = true; modData.RightForearm.ToDisplay = false; modData.RightHand.ToDisplay = false;
        modData.RightHand.IsBurn = false; modData.RightForearm.IsBurn = false;
        modData.RightArm.CicaTimeLeft = 2000 - surgeonFact * 50; modData.RightForearm.CicaTimeLeft = 2000 - surgeonFact * 50; modData.RightHand.CicaTimeLeft = 2000 - surgeonFact * 50;
    elseif bodyPart:getType() == BodyPartType.Hand_L then
        modData.LeftHand.IsCut = true;
        modData.LeftHand.ToDisplay = true;
        modData.LeftHand.CicaTimeLeft = 1700 - surgeonFact * 50;
    elseif bodyPart:getType() == BodyPartType.ForeArm_L then
        modData.LeftForearm.IsCut = true; modData.LeftHand.IsCut = true;
        modData.LeftForearm.ToDisplay = true; modData.LeftHand.ToDisplay = false;
        modData.LeftHand.IsBurn = false;
        modData.LeftForearm.CicaTimeLeft = 1800 - surgeonFact * 50; modData.LeftHand.CicaTimeLeft = 1800 - surgeonFact * 50;
    elseif bodyPart:getType() == BodyPartType.UpperArm_L then
        modData.LeftArm.IsCut = true; modData.LeftForearm.IsCut = true; modData.LeftHand.IsCut = true;
        modData.LeftArm.ToDisplay = true; modData.LeftForearm.ToDisplay = false; modData.LeftHand.ToDisplay = false;
        modData.LeftHand.IsBurn = false; modData.LeftForearm.IsBurn = false;
        modData.LeftArm.CicaTimeLeft = 2000 - surgeonFact * 50; modData.LeftForearm.CicaTimeLeft = 2000 - surgeonFact * 50; modData.LeftHand.CicaTimeLeft = 2000 - surgeonFact * 50;
    end

    --Heal the infection
    local bd = player:getBodyDamage()
    if bodyPart:getType() == BodyPartType.Hand_R then
        if bd:getInfectionLevel() < 20 and modData.RightHand.IsInfected and not (modData.RightForearm.IsInfected or modData.RightArm.IsInfected or modData.LeftArm.IsInfected or modData.LeftForearm.IsInfected or modData.LeftHand.IsInfected or modData.OtherBody_IsInfected) then
            player:Say("I healed !");
            bd:getBodyPart(BodyPartType.Hand_R):SetBitten(false);
            cureInfection(bd);
        else
            player:Say("I did that for nothing...");
        end
        modData.RightHand.IsInfected = false;
    elseif bodyPart:getType() == BodyPartType.ForeArm_R then
        if bd:getInfectionLevel() < 20 and modData.RightForearm.IsInfected and not (modData.RightArm.IsInfected or modData.LeftArm.IsInfected or modData.LeftForearm.IsInfected or modData.LeftHand.IsInfected or modData.OtherBody_IsInfected) then
            player:Say("I healed !");
            bd:getBodyPart(BodyPartType.Hand_R):SetBitten(false); bd:getBodyPart(BodyPartType.ForeArm_R):SetBitten(false);
            cureInfection(bd);
        else
            player:Say("I did that for nothing...");
        end
        modData.RightHand.IsInfected = false;
        modData.RightForearm.IsInfected = false;
    elseif bodyPart:getType() == BodyPartType.UpperArm_R then
        if bd:getInfectionLevel() < 20 and modData.RightArm.IsInfected and not (modData.LeftArm.IsInfected or modData.LeftForearm.IsInfected or modData.LeftHand.IsInfected or modData.OtherBody_IsInfected) then
            player:Say("I healed !");
            bd:getBodyPart(BodyPartType.Hand_R):SetBitten(false); bd:getBodyPart(BodyPartType.ForeArm_R):SetBitten(false); bd:getBodyPart(BodyPartType.UpperArm_R):SetBitten(false);
            cureInfection(bd);
        else
            player:Say("I did that for nothing...");
        end
        modData.RightHand.IsInfected = false; modData.RightForearm.IsInfected = false; modData.RightArm.IsInfected = false;
    elseif bodyPart:getType() == BodyPartType.Hand_L then
        if bd:getInfectionLevel() < 20 and modData.LeftHand.IsInfected and not (modData.RightForearm.IsInfected or modData.RightArm.IsInfected or modData.LeftArm.IsInfected or modData.LeftForearm.IsInfected or modData.RightHand.IsInfected or modData.OtherBody_IsInfected) then
            player:Say("I healed !");
            bd:getBodyPart(BodyPartType.Hand_L):SetBitten(false);
            cureInfection(bd);
        else
            player:Say("I did that for nothing...");
        end
        modData.LeftHand.IsInfected = false;
    elseif bodyPart:getType() == BodyPartType.ForeArm_L then
        if bd:getInfectionLevel() < 20 and modData.LeftForearm.IsInfected and not (modData.RightForearm.IsInfected or modData.RightArm.IsInfected or modData.LeftArm.IsInfected or modData.RightHand.IsInfected or modData.OtherBody_IsInfected) then
            player:Say("I healed !");
            bd:getBodyPart(BodyPartType.Hand_L):SetBitten(false); bd:getBodyPart(BodyPartType.ForeArm_L):SetBitten(false);
            cureInfection(bd);
        else
            player:Say("I did that for nothing...");
        end
        modData.LeftHand.IsInfected = false; modData.LeftForearm.IsInfected = false;
    elseif bodyPart:getType() == BodyPartType.UpperArm_L then
        if bd:getInfectionLevel() < 20 and modData.LeftArm.IsInfected and not (modData.RightForearm.IsInfected or modData.RightArm.IsInfected or modData.RightHand.IsInfected or modData.OtherBody_IsInfected) then
            player:Say("I healed !");
            bd:getBodyPart(BodyPartType.Hand_L):SetBitten(false); bd:getBodyPart(BodyPartType.ForeArm_L):SetBitten(false); bd:getBodyPart(BodyPartType.UpperArm_L):SetBitten(false);
            cureInfection(bd);
        else
            player:Say("I did that for nothing...");
        end
        modData.LeftHand.IsInfected = false; modData.LeftForearm.IsInfected = false; modData.LeftArm.IsInfected = false;
    end

    --Equip cloth
    local cloth = player:getInventory():AddItem(find_clothName2_TOC(partName));
    player:setWornItem(cloth:getBodyLocation(), cloth);

    -- Set the correct stats for the injury
    bodyPart:setBleeding(true);
    bodyPart:setDeepWounded(true);
    bodyPart:setBleedingTime(100);
    bodyPart:setDeepWoundTime(100);

    player:transmitModData();
end

function OperateArm(partName, surgeonFact, useOven)
    local player = getPlayer();
    local modData = player:getModData().TOC;

    if UseOven then
        local stats = character:getStats();
        bodyPart:AddDamage(100);
        bodyPart:setAdditionalPain(100);
        stats:setEndurance(0);
        stats:setStress(100);
    end

    if partName == "RightHand" and not modData.RightHand.IsOperated then
        modData.RightHand.IsOperated = true;
        modData.RightHand.CicaTimeLeft = modData.RightHand.CicaTimeLeft - (surgeonFact * 200);
        if UseOven then modData.RightHand.IsBurn = true end
    elseif partName == "RightForearm" and not modData.RightForearm.IsOperated then
        modData.RightForearm.IsOperated = true;
        modData.RightHand.IsOperated = true;
        modData.RightForearm.CicaTimeLeft = modData.RightForearm.CicaTimeLeft - (surgeonFact * 200);
        modData.RightHand.CicaTimeLeft = modData.RightHand.CicaTimeLeft - (surgeonFact * 200);
        if UseOven then
            modData.TOC.RightHand.IsBurn = true;
            modData.TOC.RightForearm.IsBurn = true;
        end
    elseif partName == "RightArm" and not modData.RightArm.IsOperated then
        modData.RightArm.IsOperated = true;
        modData.RightForearm.IsOperated = true;
        modData.RightHand.IsOperated = true;
        modData.RightArm.CicaTimeLeft = modData.RightArm.CicaTimeLeft - (surgeonFact * 200);
        modData.RightForearm.CicaTimeLeft = modData.RightForearm.CicaTimeLeft - (surgeonFact * 200);
        modData.RightHand.CicaTimeLeft = modData.RightHand.CicaTimeLeft - (surgeonFact * 200);
        if UseOven then
            modData.RightHand.IsBurn = true;
            modData.RightForearm.IsBurn = true;
            modData.RightArm.IsBurn = true;
        end
    elseif partName == "LeftHand" and not modData.LeftHand.IsOperated then
        modData.LeftHand.IsOperated = true;
        modData.LeftHand.CicaTimeLeft = modData.LeftHand.CicaTimeLeft - (surgeonFact * 200);
        if UseOven then modData.LeftHand.IsBurn = true end
    elseif partName == "LeftForearm" and not modData.LeftForearm.IsOperated then
        modData.LeftForearm.IsOperated = true;
        modData.LeftHand.IsOperated = true;
        modData.LeftForearm.CicaTimeLeft = modData.LeftForearm.CicaTimeLeft - (surgeonFact * 200);
        modData.LeftHand.CicaTimeLeft = modData.LeftHand.CicaTimeLeft - (surgeonFact * 200);
        if UseOven then
            modData.LeftHand.IsBurn = true;
            modData.LeftForearm.IsBurn = true;
        end
    elseif partName == "LeftArm" and not modData.LeftArm.IsOperated then
        modData.LeftArm.IsOperated = true;
        modData.LeftForearm.IsOperated = true;
        modData.LeftHand.IsOperated = true;
        modData.LeftArm.CicaTimeLeft = modData.LeftArm.CicaTimeLeft - (surgeonFact * 200);
        modData.LeftForearm.CicaTimeLeft = modData.LeftForearm.CicaTimeLeft - (surgeonFact * 200);
        modData.LeftHand.CicaTimeLeft = modData.LeftHand.CicaTimeLeft - (surgeonFact * 200);
        if UseOven then
            modData.LeftHand.IsBurn = true;
            modData.LeftForearm.IsBurn = true;
            modData.LeftArm.IsBurn = true;
        end
    end

    FixDeepWound(partname)


    player:transmitModData();
end


function FixDeepWound(partName)

    a_rightArm = {"RightArm", "RightForearm", "RightHand"}
    a_rightForearm = {"RightForearm", "RightHand"}
    a_rightHand = {"RightHand"}

    a_leftArm = {"LeftArm", "LeftForearm", "LeftHand"}
    a_leftForearm = {"LeftForearm", "LeftHand"}
    a_leftHand = {"LeftHand"}

    
    if partName == "RightArm" then
        chosen_array = a_rightArm        

    elseif partName == "RightForearm" then 
        chosen_array = a_rightForearm        

    elseif partName == "RightHand" then 
        chosen_array = a_rightHand        

    elseif partName == "LeftArm" then 
        chosen_array = a_leftArm        

    elseif partName == "LeftForearm" then 
        chosen_array = a_leftForearm        

    elseif partName == "LeftHand" then 
        chosen_array = a_leftHand        
    end


    for k,v in pairs(chosen_array) do 
        local tmpBodyPart = bodyDamage:getBodyPart(TOC_getBodyPart(v));
        tmpBodyPart:setDeepWounded(false);      -- Basically like stictching
        tmpBodyPart:setDeepWoundTime(0);     
        bodyPart:setBleeding(true);
        bodyPart:setBleedingTime(10);   -- Reset the bleeding   

    end

end 