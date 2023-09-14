local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    
    -- JOINING
    if msgcontains(msg, "join") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers) < 1 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) < 1 then
            selfSay("Do you want to join the explorer society?", cid)
            talkState[talkUser] = 1
        end
        --The New Frontier
    elseif msgcontains(msg, "farmine") then
        if getPlayerStorageValue(cid, Storage.TheNewFrontier.Questline) <= 15 and getPlayerStorageValue(cid, Storage.TheNewFrontier.BribeExplorerSociety) < 1 then
            selfSay("Oh yes, an interesting topic. We had vivid discussions about this discovery. But what is it that you want?", cid)
            talkState[talkUser] = 30
        end
    elseif msgcontains(msg, "bluff") then
        if talkState[talkUser] == 30 then
            if getPlayerStorageValue(cid, Storage.TheNewFrontier.BribeExplorerSociety) < 1 then
                selfSay({
                    "Those stories are just amazing! Men with faces on their stomach instead of heads you say? And hens that lay golden eggs? Whereas, most amazing is this fountain of youth you've mentioned! ...",
                    "I'll immediately send some of our most dedicated explorers to check those things out!"
                }, cid)
                setPlayerStorageValue(cid, Storage.TheNewFrontier.BribeExplorerSociety, 1)
                --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
                setPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05, getPlayerStorageValue(cid, Storage.TheNewFrontier.Mission05) + 1)
            end
        end

        -- MISSION CHECK
    elseif msgcontains(msg, "mission") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers) > 3 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) > 3 and getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) < 26 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) < 26 or getPlayerStorageValue(cid, Storage.ExplorerSociety.TheIceDelivery) == 7 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 7 or getPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt) == 16 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 16 or getPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers) == 4 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 4 then
            selfSay("The missions available for your rank are the {butterfly hunt}, {plant collection} and {ice delivery}.", cid)
            talkState[talkUser] = 0
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) > 25 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) > 35 and getPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder) < 35 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) < 35 or getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) == 26 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 26 or getPlayerStorageValue(cid, Storage.ExplorerSociety.TheLizardUrn) == 29  and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 29 or getPlayerStorageValue(cid, Storage.ExplorerSociety.TheBonelordSecret) == 32 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 32 then
            selfSay("The missions available for your rank are {lizard urn}, {bonelord secrets} and {orc powder}.", cid)
            talkState[talkUser] = 0
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder) > 34 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) > 34 and getPlayerStorageValue(cid, Storage.ExplorerSociety.TheRuneWritings) < 44 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) < 44 or getPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder) == 35 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 35 or getPlayerStorageValue(cid, Storage.ExplorerSociety.TheElvenPoetry) == 38 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 38 or getPlayerStorageValue(cid, Storage.ExplorerSociety.TheMemoryStone) == 41 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 41 then
            selfSay("The missions available for your rank are {elven poetry}, {memory stone} and {rune writings}.", cid)
            talkState[talkUser] = 0
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheRuneWritings) == 44 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 44 then
            selfSay("The explorer society needs a great deal of help in the research of astral travel. Are you willing to help?", cid)
            talkState[talkUser] = 27
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheEctoplasm) == 46 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 46 then
            selfSay("Do you have some collected ectoplasm with you?", cid)
            talkState[talkUser] = 29
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheEctoplasm) == 47 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 47 then
            selfSay({
                "The research on ectoplasm makes good progress. Now we need some spectral article. Our scientists think a spectral dress would be a perfect object for their studies ...",
                "The bad news is that the only source to got such a dress is the queen of the banshees. Do you dare to seek her out?"
            }, cid)
            talkState[talkUser] = 30
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralDress) == 49 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 48 then
            selfSay("Did you bring the dress?", cid)
            talkState[talkUser] = 31
            -- SPECTRAL STONE
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralDress) == 50 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 50 then
            selfSay({
                "With the objects you've provided our researchers will make steady progress. Still we are missing some test results from fellow explorers ...",
                "Please travel to our base in Northport and ask them to mail us their latest research reports. Then return here and ask about new missions."
            }, cid)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralStone, 51)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 51)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.SpectralStone, 1)			--##############################################
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralStone) == 51 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 51 and getPlayerStorageValue(cid, Storage.ExplorerSociety.SpectralStone) == 2 then --##############################################
            selfSay("Oh, yes! Tell our fellow explorer that the papers are in the mail already.", cid)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralStone, 52)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 52)
            talkState[talkUser] = 0
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralStone) == 52  and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 52 and getPlayerStorageValue(cid, Storage.ExplorerSociety.SpectralStone) == 1 then --##############################################
            selfSay("The reports from Northport have already arrived here and our progress is astonishing. We think it is possible to create an astral bridge between our bases. Are you interested to assist us with this?", cid)
            talkState[talkUser] = 32
            -- SPECTRAL STONE
            -- ASTRAL PORTALS
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralStone) == 55 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 55 then
            selfSay({
                "Both carvings are now charged and harmonised. In theory you should be able to travel in zero time from one base to the other ...",
                "However, you will need to have an orichalcum pearl in your possession to use it as power source. It will be destroyed during the process. I will give you 6 of such pearls and you can buy new ones in our bases ...",
                "In addition, you need to be a premium explorer to use the astral travel. ...",
                "And remember: it's a small teleport for you, but a big teleport for all Tibians! Here is a small present for your efforts!"
            }, cid)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheAstralPortals, 56)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 56)
            doPlayerAddItem(cid, 5022, 6) -- orichalcum pearl
            doPlayerAddItem(cid, 10522, 1) -- crown backpack
            -- ASTRAL PORTALS
        end
        -- MISSION CHECK

        -- PICKAXE MISSION
    elseif msgcontains(msg, "pickaxe") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers) < 4 or getPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers) > 1 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) < 1 or getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) > 1 then
            selfSay("Did you get the requested pickaxe from Uzgod in Kazordoon?", cid)
            talkState[talkUser] = 3
        end
        -- PICKAXE MISSION

        -- ICE DELIVERY
    elseif msgcontains(msg, "ice delivery") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers) == 4 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 4 then
            selfSay({
                "Our finest minds came up with the theory that deep beneath the ice island of Folda ice can be found that is ancient. To prove this theory we would need a sample of the aforesaid ice ...",
                "Of course the ice melts away quickly so you would need to hurry to bring it here ...",
                "Would you like to accept this mission?"
            }, cid)
            talkState[talkUser] = 4
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheIceDelivery) == 6 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 6 then
            selfSay("Did you get the ice we are looking for?", cid)
            talkState[talkUser] = 5
        end
        -- ICE DELIVERY

        -- BUTTERFLY HUNT
    elseif msgcontains(msg, "butterfly hunt") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheIceDelivery) == 7 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 7 then
            selfSay("The mission asks you to collect some species of butterflies, are you interested?", cid)
            talkState[talkUser] = 7
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt) == 9 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 9 then
            selfSay("Did you acquire the purple butterfly we are looking for?", cid)
            talkState[talkUser] = 8
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt) == 10 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 10 then
            selfSay({
                "This preparation kit will allow you to collect a blue butterfly you have killed ...",
                "Just use it on the fresh corpse of a blue butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."
            }, cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4865, 1)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt, 11)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 11)
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt) == 12 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 12 then
            selfSay("Did you acquire the blue butterfly we are looking for?", cid)
            talkState[talkUser] = 9
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt) == 13 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 13 then
            selfSay({
                "This preparation kit will allow you to collect a red butterfly you have killed ...",
                "Just use it on the fresh corpse of a red butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."
            }, cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4865, 1)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt, 14)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 14)
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt) == 15 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 15 then
            selfSay("Did you acquire the red butterfly we are looking for?", cid)
            talkState[talkUser] = 10
        end
        -- BUTTERFLY HUNT
        -- PLANT COLLECTION
    elseif msgcontains(msg, "plant collection") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt) == 16 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 16 then
            selfSay("In this mission we require you to get us some plant samples from Tiquandan plants. Would you like to fulfil this mission?", cid)
            talkState[talkUser] = 11
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) == 18  and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 18 then
            selfSay("Did you acquire the sample of the jungle bells plant we are looking for?", cid)
            talkState[talkUser] = 12
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) == 19 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 19 then
            selfSay("Use this botanist's container on a witches cauldron to collect a sample for us. Bring it here and report about your plant collection.", cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4869, 1)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection, 20)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 20)
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) == 21 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 21 then
            selfSay("Did you acquire the sample of the witches cauldron we are looking for?", cid)
            talkState[talkUser] = 13
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) == 22 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 22 then
            selfSay("Use this botanist\'s container on a giant jungle rose to obtain a sample for us. Bring it here and report about your plant collection.", cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4869, 1)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection, 23)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 23)
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) == 24 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 24 then
            selfSay("Did you acquire the sample of the giant jungle rose we are looking for?", cid)
            talkState[talkUser] = 14
        end
        -- PLANT COLLECTION

        -- LIZARD URN
    elseif msgcontains(msg, "lizard urn") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection) == 26 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 26 then
            selfSay("The explorer society would like to acquire an ancient urn which is some sort of relic to the lizard people of Tiquanda. Would you like to accept this mission?", cid)
            talkState[talkUser] = 15
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheLizardUrn) == 28 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 27 then
            selfSay("Did you manage to get the ancient urn?", cid)
            talkState[talkUser] = 16
        end
        -- LIZARD URN

        -- BONELORDS
    elseif msgcontains(msg, "bonelord secrets") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheLizardUrn) == 29  and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 29 then
            selfSay({
                "We want to learn more about the ancient race of bonelords. We believe the black pyramid north east of Darashia was originally built by them ...",
                "We ask you to explore the ruins of the black pyramid and look for any signs that prove our theory. You might probably find some document with the numeric bonelord language ...",
                "That would be sufficient proof. Would you like to accept this mission?"
            }, cid)
            talkState[talkUser] = 17
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheBonelordSecret) == 31 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 30 then
            selfSay("Have you found any proof that the pyramid was built by bonelords?", cid)
            talkState[talkUser] = 18
        end
        -- BONELORDS

        -- ORC POWDER
    elseif msgcontains(msg, "orc powder") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheBonelordSecret) == 32 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 32 then
            selfSay({
                "It is commonly known that orcs of Uldereks Rock use some sort of powder to increase the fierceness of their war wolves and berserkers ...",
                "What we do not know are the ingredients of this powder and its effect on humans ...",
                "So we would like you to get a sample of the aforesaid powder. Do you want to accept this mission?"
            }, cid)
            talkState[talkUser] = 19
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder) == 34 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 33 then
            selfSay("Did you acquire some of the orcish powder?", cid)
            talkState[talkUser] = 20
        end
        -- ORC POWDER

        -- ELVEN POETRY
    elseif msgcontains(msg, "elven poetry") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder) == 35 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 35 then
            selfSay({
                "Some high ranking members would like to study elven poetry. They want the rare book 'Songs of the Forest' ...",
                "For sure someone in Ab'Dendriel will own a copy. So you would just have to ask around there. Are you willing to accept this mission?"
            }, cid)
            talkState[talkUser] = 21
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheElvenPoetry) == 37 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 36 then
            selfSay("Did you acquire a copy of 'Songs of the Forest' for us?", cid)
            talkState[talkUser] = 22
        end
        -- ELVEN POETRY

        -- MEMORY STONE
    elseif msgcontains(msg, "memory stone") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheElvenPoetry) == 38 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 38 then
            selfSay({
                "We acquired some knowledge about special magic stones. Some lost civilisations used it to store knowledge and lore, just like we use books ...",
                "The wisdom in such stones must be immense, but so are the dangers faced by every person who tries to obtain one...",
                "As far as we know the ruins found in the north-west of Edron were once inhabited by beings who used such stones. Do you have the heart to go there and to get us such a stone?"
            }, cid)
            talkState[talkUser] = 23
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheMemoryStone) == 40 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 39 then
            selfSay("Were you able to acquire a memory stone for our society?", cid)
            talkState[talkUser] = 24
        end
        -- MEMORY STONE

        -- RUNE WRITINGS
    elseif msgcontains(msg, "rune writings") then
        if getPlayerStorageValue(cid, Storage.ExplorerSociety.TheMemoryStone) == 41 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 41 then
            selfSay({
                "We would like to study some ancient runes that were used by the lizard race. We suspect some relation of the lizards to the founders of Ankrahmun ...",
                "Somewhere under the ape infested city of Banuta, one can find dungeons that were once inhabited by lizards...",
                "Look there for an atypical structure that would rather fit to Ankrahmun and its Ankrahmun Tombs. Copy the runes you will find on this structure...",
                "Are you up to that challenge?"
            }, cid)
            talkState[talkUser] = 25
        elseif getPlayerStorageValue(cid, Storage.ExplorerSociety.TheRuneWritings) == 43 and getPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine) == 43 then
            selfSay("Did you create a copy of the ancient runes as requested?", cid)
            talkState[talkUser] = 26
        end
        -- RUNE WRITINGS

        -- ANSWER YES
    elseif msgcontains(msg, "yes") then
        if talkState[talkUser] == 1 then
            selfSay({
                "Fine, though it takes more then a mere lip service to join our ranks. To prove your dedication to the cause you will have to acquire an item for us ...",
                "The mission should be simple to fulfil. For our excavations we have ordered a sturdy pickaxe in Kazordoon. You would have to seek out this trader Uzgod and get the pickaxe for us ...",
                "Simple enough? Are you interested in this task?"
            }, cid)
            talkState[talkUser] = 2
        elseif talkState[talkUser] == 2 then
            selfSay("We will see if you can handle this simple task. Get the pickaxe from Uzgod in Kazordoon and bring it to one of our bases. Report there about the pickaxe.", cid)
            talkState[talkUser] = 0
            setPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers, 1)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 1)
        elseif talkState[talkUser] == 3 then
            if doPlayerRemoveItem(cid, 4874, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.JoiningtheExplorers, 4)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 4)
                selfSay({
                    "Excellent, you brought just the tool we need! Of course it was only a simple task. However ...",
                    "I officially welcome you to the explorer society. From now on you can ask for missions to improve your rank."
                }, cid)
                talkState[talkUser] = 0
            end
        elseif talkState[talkUser] == 4 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheIceDelivery, 5)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 5)
            selfSay({
                "So listen please: Take this ice pick and use it on a block of ice in the caves beneath Folda. Get some ice and bring it here as fast as you can ...",
                "Should the ice melt away, report on your ice delivery mission anyway. I will then tell you if the time is right to start another mission."
            }, cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4856, 1)
        elseif talkState[talkUser] == 5 then
            if doPlayerRemoveItem(cid, 4848, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheIceDelivery, 7)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 7)
                selfSay("Just in time. Sadly not much ice is left over but it will do. Thank you again.", cid)
                talkState[talkUser] = 0
            end
        elseif talkState[talkUser] == 6 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheIceDelivery, 5)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 5)
            selfSay("*Sigh* I think the time is right to grant you another chance to get that ice. Hurry up this time.", cid)
            talkState[talkUser] = 0

            -- BUTTERFLY HUNT
        elseif talkState[talkUser] == 7 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt, 8)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 8)
            selfSay({
                "This preparation kit will allow you to collect a purple butterfly you have killed ...",
                "Just use it on the fresh corpse of a purple butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."
            }, cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4865, 1)
        elseif talkState[talkUser] == 8 then
            if doPlayerRemoveItem(cid, 4866, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt, 10)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 10)
                selfSay("A little bit battered but it will do. Thank you! If you think you are ready, ask for another butterfly hunt.", cid)
                talkState[talkUser] = 0
            end
        elseif talkState[talkUser] == 9 then
            if doPlayerRemoveItem(cid, 4867, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt, 13)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 13)
                selfSay("A little bit battered but it will do. Thank you! If you think you are ready, ask for another butterfly hunt.", cid)
                talkState[talkUser] = 0
            end
        elseif talkState[talkUser] == 10 then
            if doPlayerRemoveItem(cid, 4868, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheButterflyHunt, 16)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 16)
                selfSay("That is an extraordinary species you have brought. Thank you! That was the last butterfly we needed.", cid)
                talkState[talkUser] = 0
            end
            -- BUTTERFLY HUNT

            -- PLANT COLLECTION
        elseif talkState[talkUser] == 11 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection, 17)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 17)
            selfSay("Fine! Here take this botanist's container. Use it on a jungle bells plant to collect a sample for us. Report about your plant collection when you have been successful.", cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4869, 1)
        elseif talkState[talkUser] == 12 then
            if doPlayerRemoveItem(cid, 4870, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection, 19)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 19)
                selfSay("I see. It seems you've got some quite useful sample by sheer luck. Thank you! Just tell me when you are ready to continue with the plant collection.", cid)
                talkState[talkUser] = 0
            end
        elseif talkState[talkUser] == 13 then
            if doPlayerRemoveItem(cid, 4871, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection, 22)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 22)
                selfSay("Ah, finally. I started to wonder what took you so long. But thank you! Another fine sample, indeed. Just tell me when you are ready to continue with the plant collection.", cid)
                talkState[talkUser] = 0
            end
        elseif talkState[talkUser] == 14 then
            if doPlayerRemoveItem(cid, 4872, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.ThePlantCollection, 26)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 26)
                selfSay("What a lovely sample! With that you have finished your plant collection missions.", cid)
                talkState[talkUser] = 0
            end
            -- PLANT COLLECTION

            -- LIZARD URN
        elseif talkState[talkUser] == 15 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheLizardUrn, 27)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 27)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.urnDoor, 1)
            selfSay({
                "You have indeed the spirit of an adventurer! In the south-east of Tiquanda is a small settlement of the lizard people ...",
                "Beneath the newly constructed temple there, the lizards hide the said urn. Our attempts to acquire this item were without success ...",
                "Perhaps you are more successful."
            }, cid)
            talkState[talkUser] = 0
        elseif talkState[talkUser] == 16 then
            if doPlayerRemoveItem(cid, 4858, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheLizardUrn, 29)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 29)
                selfSay("Yes, that is the prized relic we have been looking for so long. You did a great job, thank you.", cid)
                talkState[talkUser] = 0
            end
            -- LIZARD URN

            -- BONELORDS
        elseif talkState[talkUser] == 17 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheBonelordSecret, 30)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 30)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.bonelordsDoor, 1)
            selfSay({
                "Excellent! So travel to the city of Darashia and then head north-east for the pyramid ...",
                "If any documents are left, you probably find them in the catacombs beneath. Good luck!"
            }, cid)
            talkState[talkUser] = 0
        elseif talkState[talkUser] == 18 then
            if doPlayerRemoveItem(cid, 4857, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheBonelordSecret, 32)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 32)
                selfSay("You did it! Excellent! The scientific world will be shaken by this discovery!", cid)
                talkState[talkUser] = 0
            end
            -- BONELORDS

            -- ORC POWDER
        elseif talkState[talkUser] == 19 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder, 33)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 33)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.orcDoor, 1)
            selfSay({
                "You are a brave soul. As far as we can tell, the orcs maintain some sort of training facility in some hill in the north-east of their city ...",
                "There you should find lots of their war wolves and hopefully also some of the orcish powder. Good luck!"
            }, cid)
            talkState[talkUser] = 0
        elseif talkState[talkUser] == 20 then
            if doPlayerRemoveItem(cid, 4849, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheOrcPowder, 35)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 35)
                selfSay("You really got it? Amazing! Thank you for your efforts.", cid)
                talkState[talkUser] = 0
            end
            -- ORC POWDER

            -- ELVEN POETRY
        elseif talkState[talkUser] == 21 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheElvenPoetry, 36)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 36)
            selfSay("Excellent. This mission is easy but nonetheless vital. Travel to Ab'Dendriel and get the book.", cid)
            talkState[talkUser] = 0
        elseif talkState[talkUser] == 22 then
            if doPlayerRemoveItem(cid, 4855, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheElvenPoetry, 38)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 38)
                selfSay("Let me have a look! Yes, that's what we wanted. A copy of 'Songs of the Forest'. I won't ask any questions about those bloodstains.", cid)
                talkState[talkUser] = 0
            end
            -- ELVEN POETRY

            -- MEMORY STONE
        elseif talkState[talkUser] == 23 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheMemoryStone, 39)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 39)
            setPlayerStorageValue(cid, Storage.ExplorerSociety.edronDoor, 1)
            selfSay("In the ruins of north-western Edron you should be able to find a memory stone. Good luck.", cid)
            talkState[talkUser] = 0
        elseif talkState[talkUser] == 24 then
            if doPlayerRemoveItem(cid, 4852, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheMemoryStone, 41)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 41)
                selfSay("A flawless memory stone! Incredible! It will take years even to figure out how it works but what an opportunity for science, thank you!", cid)
                talkState[talkUser] = 0
            end
            -- MEMORY STONE

            -- RUNE WRITINGS
        elseif talkState[talkUser] == 25 then
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheRuneWritings, 42)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 42)
            selfSay("Excellent! Here, take this tracing paper and use it on the object you will find there to create a copy of the ancient runes.", cid)
            talkState[talkUser] = 0
            doPlayerAddItem(cid, 4853, 1)
        elseif talkState[talkUser] == 26 then
            if doPlayerRemoveItem(cid, 4854, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheRuneWritings, 44)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 44)
                selfSay("It's a bit wrinkled but it will do. Thanks again.", cid)
                talkState[talkUser] = 0
            end
            -- RUNE WRITINGS

            -- ECTOPLASM
        elseif talkState[talkUser] == 27 then
            selfSay({
                "Fine. The society is looking for new means to travel. Some of our most brilliant minds have some theories about astral travel that they want to research further ...",
                "Therefore we need you to collect some ectoplasm from the corpse of a ghost. We will supply you with a collector that you can use on the body of a slain ghost ...",
                "Do you think you are ready for that mission?"
            }, cid)
            talkState[talkUser] = 28
        elseif talkState[talkUser] == 28 then
            selfSay("Good! Take this container and use it on a ghost that was recently slain. Return with the collected ectoplasm and hand me that container ...", cid)
            selfSay("Don't lose the container. They are expensive!", cid)
            talkState[talkUser] = 0
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheEctoplasm, 45)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 45)
            doPlayerAddItem(cid, 4863, 1)
        elseif talkState[talkUser] == 29 then
            if doPlayerRemoveItem(cid, 8182, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheEctoplasm, 47)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 47)
                selfSay("Phew, I had no idea that ectoplasm would smell that ... oh, it's you, well, sorry. Thank you for the ectoplasm.", cid)
                talkState[talkUser] = 0
            end
            -- ECTOPLASM

            -- SPECTRAL DRESS
        elseif talkState[talkUser] == 30 then
            selfSay({
                "That is quite courageous. We know, it's much we are asking for. The queen of the banshees lives in the so called Ghostlands, south west of Carlin. It is rumoured that her lair is located in the deepest dungeons beneath that cursed place ...",
                "Any violence will probably be futile, you will have to negotiate with her. Try to get a spectral dress from her. Good luck."
            }, cid)
            talkState[talkUser] = 0
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralDress, 48)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 48)
        elseif talkState[talkUser] == 31 then
            if doPlayerRemoveItem(cid, 4847, 1) then
                setPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralDress, 50)
				setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 50)
                selfSay("Good! Ask me for another mission.", cid)
                talkState[talkUser] = 0
            end
            -- SPECTRAL DRESS

            -- SPECTRAL STONE
        elseif talkState[talkUser] == 32 then
            selfSay({
                "Good, just take this spectral essence and use it on the strange carving in this building as well as on the corresponding tile in our base at Northport ...",
                "As soon as you have charged the portal tiles that way, report about the spectral portals."
            }, cid)
            talkState[talkUser] = 0
            setPlayerStorageValue(cid, Storage.ExplorerSociety.TheSpectralStone, 53)
			setPlayerStorageValue(cid, Storage.ExplorerSociety.QuestLine, 53)
            doPlayerAddItem(cid, 4851, 1) -- spectral stone
            -- SPECTRAL STONE

            -- SKULL OF RATHA / GIANT SMITHHAMMER
        elseif talkState[talkUser] == 33 then
            if doPlayerRemoveItem(cid, 2320, 1) then
                selfSay("Poor Ratha. Thank you for returning this skull to the society. We will see to a honourable burial of Ratha.", cid)
                setPlayerStorageValue(cid, Storage.ExplorerSociety.skullofratha, 1)
                doPlayerAddItem(cid, 2152, 2)
                doPlayerAddItem(cid, 2148, 50)
                talkState[talkUser] = 0
            else
                selfSay("Come back when you find any information.", cid)
                talkState[talkUser] = 0
            end
        elseif talkState[talkUser] == 34 then
            if doPlayerRemoveItem(cid, 2321, 1) then
                selfSay("Marvellous! You brought a giant smith hammer for the explorer society!", cid)
                setPlayerStorageValue(cid, Storage.ExplorerSociety.giantsmithhammer, 1)
                doPlayerAddItem(cid, 2152, 2)
                doPlayerAddItem(cid, 2148, 50)
                talkState[talkUser] = 0
            else
                selfSay("No you don\'t.", cid)
                talkState[talkUser] = 0
            end
            -- SKULL OF RATHA / GIANT SMITHHAMMER
        end
        -- ANSWER YES

        -- ANSWER NO
    elseif msgcontains(msg, "no") then
        if talkState[talkUser] == 5 then
            selfSay("Did it melt away?", cid)
            talkState[talkUser] = 6
        elseif talkState[talkUser] == 33 then
            selfSay("Come back when you find any information.", cid)
            talkState[talkUser] = 0
        elseif talkState[talkUser] == 34 then
            selfSay("Come back when you find one.", cid)
            talkState[talkUser] = 0
        end
        -- ANSWER NO

        -- SKULL OF RATHA / GIANT SMITHHAMMER
    elseif msgcontains(msg, "skull of ratha") and getPlayerStorageValue(cid, Storage.ExplorerSociety.skullofratha) < 1 then
        selfSay({
            "Ratha was a great explorer and even greater ladies' man. Sadly he never returned from a visit to the amazons. Probably he is dead ...",
            "The society offers a substantial reward for the retrieval of Ratha or his remains. Do you have any news about Ratha?"
        }, cid)
        talkState[talkUser] = 33
    elseif msgcontains(msg, "giant smith hammer") and getPlayerStorageValue(cid, Storage.ExplorerSociety.giantsmithhammer) < 1 then
        selfSay("The explorer society is looking for a genuine giant smith hammer for our collection. It is rumoured the cyclopses of the Plains of Havoc might be using one. Did you by chance obtain such a hammer?", cid)
        talkState[talkUser] = 34
        -- SKULL OF RATHA / GIANT SMITHHAMMER
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
