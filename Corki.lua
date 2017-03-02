local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Corki" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Corki/master/Corki.lua', SCRIPT_PATH .. 'Corki.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Corki/master/Corki.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local CorkiMenu = Menu("Corki", "Corki")

CorkiMenu:SubMenu("Combo", "Combo")

CorkiMenu.Combo:Boolean("Q", "Use Q in combo", true)
CorkiMenu.Combo:Boolean("W", "Use W in combo", true)
CorkiMenu.Combo:Boolean("E", "Use E in combo", true)
CorkiMenu.Combo:Boolean("R", "Use R in combo", true)
CorkiMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
CorkiMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
CorkiMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
CorkiMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
CorkiMenu.Combo:Boolean("RHydra", "Use RHydra", true)
CorkiMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
CorkiMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
CorkiMenu.Combo:Boolean("Randuins", "Use Randuins", true)


CorkiMenu:SubMenu("AutoMode", "AutoMode")
CorkiMenu.AutoMode:Boolean("Level", "Auto level spells", false)
CorkiMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
CorkiMenu.AutoMode:Boolean("Q", "Auto Q", false)
CorkiMenu.AutoMode:Boolean("W", "Auto W", false)
CorkiMenu.AutoMode:Boolean("E", "Auto E", false)
CorkiMenu.AutoMode:Boolean("R", "Auto R", false)

CorkiMenu:SubMenu("LaneClear", "LaneClear")
CorkiMenu.LaneClear:Boolean("Q", "Use Q", true)
CorkiMenu.LaneClear:Boolean("W", "Use W", true)
CorkiMenu.LaneClear:Boolean("E", "Use E", true)
CorkiMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
CorkiMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

CorkiMenu:SubMenu("Harass", "Harass")
CorkiMenu.Harass:Boolean("Q", "Use Q", true)
CorkiMenu.Harass:Boolean("W", "Use W", true)

CorkiMenu:SubMenu("KillSteal", "KillSteal")
CorkiMenu.KillSteal:Boolean("Q", "KS w Q", true)
CorkiMenu.KillSteal:Boolean("E", "KS w E", true)

CorkiMenu:SubMenu("AutoIgnite", "AutoIgnite")
CorkiMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

CorkiMenu:SubMenu("Drawings", "Drawings")
CorkiMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

CorkiMenu:SubMenu("SkinChanger", "SkinChanger")
CorkiMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
CorkiMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if CorkiMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if CorkiMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 825) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if CorkiMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 600) then
				CastSkillShot(_W, target)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if CorkiMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if CorkiMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if CorkiMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if CorkiMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if CorkiMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 600) then
			 CastSkillShot(_E, target)
	    end

            if CorkiMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 825) then
		     if target ~= nil then 
                         CastTargetSpell(target, _Q)
                     end
            end

            if CorkiMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if CorkiMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if CorkiMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if CorkiMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 600) then
			CastSkillShot(_W, target)
	    end
	    
	    
            if CorkiMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1225) and (EnemiesAround(myHeroPos(), 1225) >= CorkiMenu.Combo.RX:Value()) then
			CastSkillShot(_R, target)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and CorkiMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 600) and CorkiMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSkillShot(_E, target)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if CorkiMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 825) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if CorkiMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 600) then
	        	CastSkillShot(_W, target)
	        end

                if CorkiMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 600) then
	        	CastSkillShot(_E, target)
	        end

                if CorkiMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if CorkiMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if CorkiMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 825) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if CorkiMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 600) then
	  	      CastSkillShot(_W, target)
          end
        end
        if CorkiMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 600) then
		      CastSkillShot(_E, target)
	  end
        end
        if CorkiMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 1225) then
		     CastSkillShot(_R, target)
	  end
        end
                
	--AUTO GHOST
	if CorkiMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if CorkiMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 825, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("Corkiempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if CorkiMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Corki</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





