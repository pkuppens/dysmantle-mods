quest <- {
	category =    "MAIN_QUEST"
	name =        "The Call of Mana"
	description = "You suddenly get the feeling that you should go somewhere. As if some force is pulling you towards it. Find out what is causing it."
	description_when_completed = "The Call of Mana is treacherous and as a result, the world has suffered the consequences. Though new ways have been opened to explore what has been left behind."
	image =       "quests/gfx/header-dlc1.png"
	requires_iap = "DLC1"

	phases = [
		{
			id = "PHASE_GO_TO_LINK_TOWER"
			description = ""
			reward_xp = 2000

			goals = [
						{

							id = "GOAL_SCAN_ANOMALIES"
							description = "Find any [ORANGE]Link Tower[WHITE] to [GREEN]Scan Anomalous Signals[WHITE]."
							actor_id = "TOWER_E"
							quest_marker_stage_object_id = "TOWER_E"

							function OnActorInteraction(interactive_actor, interactor_actor, interaction_id){

								if (StageObject_GetId(interactive_actor) == actor_id)
								{
									if (interaction_id == "Action_ScanAnomalies")
										SetCurrentPhaseGoalCompletedById(id);
								}

							}


						}
					]
		},
		{
			id = "PHASE_GO_TO_ENTRANCE"
			reward_xp = 2000

			goals = [
				{
					id = "GOAL_INVESTIGATE"
					description = "[GREEN]Investigate[WHITE] the [ORANGE]Anomalous Signal[WHITE]."
					quest_marker_stage_object_id = "dlc_1_entrance"
					actor_id = "dlc_1_entrance"

					function OnInitialize(){

						//Game_SetWorldState("DLC_1", "DLC_ENTRANCE", "1")
					}

					/*
					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}
					}
					*/

					function OnActorInteraction(interactive_actor, interactor_actor, interaction_id){

						 if (StageObject_GetId(interactive_actor) == actor_id && interaction_id == "investigate")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}

					}

				}

			]
		},
		{

			id = "PHASE_USE_ENTRANCE"
			goals = [
				{
					id = "GOAL_USE_ENTRANCE"
					description = "[GREEN]Descend[WHITE] to the chasm at [LOCATION=CAVE_ENTRANCE] and follow the [ORANGE]Anomalous Signal[WHITE]."
					actor_id = "catacombs_midway_entrance"
					quest_marker_stage_object_id = "dlc_1_entrance"

					function OnActorInteraction(interactive_actor, interactor_actor, interaction_id){

						 if (StageObject_GetId(interactive_actor) == actor_id && interaction_id == "descend")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}

					}

				}
			]

		},
		{
			id = "PHASE_EXPLORE_CATACOMBS"
			reward_xp = 4000
			goals = [
				{
					id = "GOAL_INVESTIGATE_CATACOMBS"
					description = "Investigate [ORANGE]The Catacombs[WHITE]."
					quest_marker_stage_object_id = "dlc_1_entrance"

					actor_id = "CATACOMBS_TABLET_03"

					function OnActorInteraction(interactive_actor, interactor_actor, interaction_id)
					{
						local so = StageObject_GetById(actor_id);

						if (so == interactive_actor && interaction_id == "open_portal")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}
					}

				}
			]

		},
		{
			id = "PHASE_DOORWAY"
			description = "Go through the [ORANGE]Gate of Mist[WHITE]."

			goals = [
				{

					id = "GOAL_DOORWAY_ENTER"
					description = "Go to the [ORANGE]Gate of Mist[WHITE] and [GREEN]Enter[WHITE] it."
					actor_id = "catacombs_doorway"
					quest_marker_stage_object_id = "catacombs_doorway"

					function OnInitialize(){

						local doorway_entrance = Stage_GetStageObjectById("catacombs_doorway");

						if(doorway_entrance != null){
							local so_player = Game_GetPrimaryPlayerActor();
							Actor_InteractWithInteraction(doorway_entrance, so_player, "init");
						}
					}

					function OnActorInteraction(interactive_actor, interactor_actor, interaction_id){

						 if (StageObject_GetId(interactive_actor) == actor_id && interaction_id == "enter")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}

					}
				}
			]
		},
		{
		reward_xp = 4000

			id = "PHASE_EXPLORE"
			description = "Investigate the area."

			goals = [

				{
					id = "GOAL_SCAN_ENERGY_RELAY"
					description = "Go deeper into the [ORANGE]Underworld[WHITE] to get the [ORANGE]Anomalous Signal[WHITE] back."
					quest_location = "SOUTHERN_TOWN"

					function OnInitialize(){
						//Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", false);
					}

					function OnEnterLocation(location_id, new_location)
					{
						if (location_id == quest_location)
							SetCurrentPhaseGoalCompletedById(id);
					}

				}
			]
		},
		{
			id = "PHASE_RADIO_SIGNAL"
			reward_xp = 8000

			description = "Follow the [ORANGE]Anomalous Signal[WHITE] and explore the [ORANGE]Underworld[WHITE] further."

			goals = [

				{
					id = "GOAL_ENTER_RADIATION"
					description = "Travel to the [GREEN]Anomalous Signal[WHITE] source."
					quest_marker_stage_object_id = "SIGNAL_SOURCE"

					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}
					}

				}
			]
		},
		{
			id = "PHASE_COLLECTOR_RELAY"
			description = "Investigate the [ORANGE]Town Relay[WHITE]."
			reward_xp = 2000

			goals = [

				{
					id = "GOAL_COLLECTOR_RELAY_MESSAGES"
					description = "Investigate the [LOCATION=DLC1_TOWN_RELAY]."
					actor_id = "collector_relay_message"

					function OnInitialize()
					{
						CheckCompletion();
						/*
						if (Game_IsPUIDMarkedDestroyed(1590333))
						{
							SetCurrentPhaseGoalCompletedById(id);
							return;
						}
						*/

					}

					function OnCommandWord(command_word)
					{

						if (command_word == "activate")
						{

							CheckCompletion();

						}
					}


					function CheckCompletion()
					{
						local clues_read = Profile_GetValue("QUESTS", "quests/dlc_1_main.nut", "num_collector_relay_messages_read");

						if(clues_read != null && clues_read.tointeger() > 2) {

							local so_player = Game_GetPrimaryPlayerActor();
							local remark = LOC_TEXT("I should try and [GREEN]Overload[WHITE] that closest one first for testing purposes.");
							Game_AddActorNotification(so_player, remark);
							SetCurrentPhaseGoalCompletedById(id);
						}

					}


				}
			]
		},
		{
			id = "PHASE_DISABLE_FIRST_RELAY"
			description = "[GREEN]Overload[WHITE] the Energy Relay at the [LOCATION=DLC1_TOWN_RELAY]."
			reward_xp = 2000
			goals = [
				{
					id = "GOAL_DISABLE_RELAY"
					description = "[GREEN]Overload[WHITE] the Energy Relay at the [LOCATION=DLC1_TOWN_RELAY]."
					actor_id = "ENERGY_RELAY_TOWN"
					quest_marker_stage_object_id = "ENERGY_RELAY_TOWN"

					/*
					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
						{
							local so_player = Game_GetPrimaryPlayerActor();
							local remark_1 = LOC_TEXT("That did the trick.");
							local remark_2 = LOC_TEXT("And now to find the rest of them [GREEN]Energy Relays[WHITE].");
							Game_AddActorNotificationWithDelay(so_player, remark_1, 3);
							Game_AddActorNotification(so_player, remark_2);
							SetCurrentPhaseGoalCompletedById(id);
						}

					}
					*/

					function OnActorInteraction(interactive_actor, interactor_actor, interaction_id)
					{
						if (StageObject_GetId(interactive_actor) == actor_id && interaction_id == "overload")
						{
							local so_player = Game_GetPrimaryPlayerActor();
							local remark_1 = LOC_TEXT("That did the trick.");
							local remark_2 = LOC_TEXT("And now to find the rest of those [GREEN]Energy Relays[WHITE].");
							Game_AddActorNotificationWithDelay(so_player, remark_1, 3);
							Game_AddActorNotification(so_player, remark_2);
							SetCurrentPhaseGoalCompletedById(id);
						}
					}


				}
			]
		},
		{
			id = "PHASE_DEACTIVATE_RELAYS"
			description = "Energy Link Relay network needs to be shut down for the Radiation Effects to stop at the [ORANGE]Anomalous Signal Source[WHITE]."
			reward_xp = 8000
			goals = [

				{
					id = "ACTIVATE_RELAY_3"
					quest_marker_stage_object_id = "ENERGY_RELAY_3"
					description = "[GREEN]Overload[WHITE] the Arrowhead Relay"

					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
							CheckCompletion();
					}

					function CheckCompletion()
					{
						if (Game_GetWorldState("DLC_1_MAIN_QUEST", quest_marker_stage_object_id) != null)
							SetCurrentPhaseGoalCompletedById(id);
					}
				}
				{
					id = "ACTIVATE_RELAY_2"
					quest_marker_stage_object_id = "ENERGY_RELAY_2"
					description = "[GREEN]Overload[WHITE] the The Colony Relay"

					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
							CheckCompletion();
					}

					function CheckCompletion()
					{
						if (Game_GetWorldState("DLC_1_MAIN_QUEST", quest_marker_stage_object_id) != null)
							SetCurrentPhaseGoalCompletedById(id);
					}
				}
				{
					id = "ACTIVATE_RELAY_1"
					quest_marker_stage_object_id = "ENERGY_RELAY_1"
					description = "[GREEN]Overload[WHITE] the Bunker Relay"

					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
							CheckCompletion();
					}

					function CheckCompletion()
					{
						if (Game_GetWorldState("DLC_1_MAIN_QUEST", quest_marker_stage_object_id) != null)
							SetCurrentPhaseGoalCompletedById(id);
					}
				}
				{
					id = "ACTIVATE_RELAY_0"
					quest_marker_stage_object_id = "ENERGY_RELAY_0"
					description = "[GREEN]Overload[WHITE] the Jalopy Relay"

					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
							CheckCompletion();
					}

					function CheckCompletion()
					{
						if (Game_GetWorldState("DLC_1_MAIN_QUEST", quest_marker_stage_object_id) != null)
							SetCurrentPhaseGoalCompletedById(id);
					}
				}


			]
		},
		{
			id = "PHASE_BACK_TO_TOWN"
			description = "[GREEN]Investigate[WHITE] the [ORANGE]Anomalous Signal[WHITE] source."
			reward_xp = 2000

			//reward_string = "???"
			goals = [
				{
					id = "GOAL_ENTER_TOWN_TOWER"
					description = "[GREEN]Investigate[WHITE] the [ORANGE]Anomalous Signal[WHITE] source."
					quest_location = "DLC1_SIGNAL_SOURCE"
					quest_marker_stage_object_id = "DLC1_TOWER_A"

					function OnInitialize()
					{

						local kvs_stage = Stage_GetKeyValueStore();
						local stage_name =  Stage_GetFilename();

						if(stage_name == "stages/dlc1/index.xml"){
							Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", false);
							KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);

						}

					}


					function OnCommandWord(command_word)
					{
						if (command_word == "complete"){
							SetCurrentPhaseGoalCompletedById(id);
							//CheckCompletion();
						}
					}


					function CheckCompletion()
					{
					//    SetCurrentPhaseGoalCompletedById(id);
					}


					/*
					function OnEnterLocation(location_id, new_location)
					{
						if (location_id == quest_location)
							SetCurrentPhaseGoalCompletedById(id);
					}
					*/

				}

			]
		},
		{
		id = "PHASE_INVESTIGATE_LINK_TOWER"
		description = "[ORANGE]Old Link Tower[WHITE]."


		goals = [
			{
				id = "GOAL_INVESTIGATE_ANTENNA"
				description = "Inspect the [ORANGE]Link Tower[WHITE] at [LOCATION=DLC1_SIGNAL_SOURCE]."
				quest_marker_stage_object_id = "DLC1_TOWER_A"
				actor_id = "DLC1_TOWER_A"


				function OnInitialize()
				{
					//what
					//Game_SetWorldState("FIXABLES", "DLC_TOWER_A", "UNSET");
					Game_RemoveWorldState("FIXABLES", "DLC_TOWER_A");


					local kvs_stage = Stage_GetKeyValueStore();
					local stage_name =  Stage_GetFilename();

					if(stage_name == "stages/dlc1/index.xml")
						KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);

				}


				function OnCommandWord(command_word)
				{
					if (command_word == "activate"){
						SetCurrentPhaseGoalCompletedById(id);

						//CheckCompletion();
					}
				}


				/*
				function OnActorInteraction(interactive_actor, interactor_actor, interaction_id)
				{
					if (StageObject_GetId(interactive_actor) == actor_id && interaction_id == "investigate")
					{
						local so_player = Game_GetPrimaryPlayerActor();
						local remark_1 = LOC_TEXT("The antenna was equipped with a [ORANGE]Campfire Triangulation[WHITE] transmitter.");
						local remark_2 = LOC_TEXT("Destroying those relays must have broken it. Shouldn't be too hard to replace.");
						//local remark_3 = LOC_TEXT("It's allowing me to move at speed of thought between the campfires.");
						Game_AddActorNotificationWithDelay(so_player, remark_1, 3);
						Game_AddActorNotification(so_player, remark_2);
						//Game_AddActorNotification(so_player, remark_3);
						SetCurrentPhaseGoalCompletedById(id);
					}
				}
				*/

			}
		]
		},

		{
			id = "PHASE_FIX_TOWER"
			description = "[ORANGE]Broken Old Link Tower[WHITE]."
			reward_xp = 8000

			goals = [
				{

					id = "GOAL_FIX_LINK_TOWER"
					titanium_amount = 4
					steel_amount = 8
					description = "[GREEN]Fix[WHITE] the Link Tower at [LOCATION=DLC1_SIGNAL_SOURCE]. ([VAR.titanium_amount]x[MATERIAL_ICON=TITANIUM] [VAR.steel_amount]x[MATERIAL_ICON=STEEL])"
					quest_marker_stage_object_id = "DLC1_TOWER_A"

					function OnInitialize()
					{
						local kvs_stage = Stage_GetKeyValueStore();
						KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);
						local linktower = Stage_GetStageObjectById("DLC1_TOWER_A");

						if(linktower != null){
							Actor_InteractWithInteraction(linktower, linktower, "init_fix");
						}
						else {
							//Engine_Warning("actor not found");
						}

						CheckCompletion();
					}

					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
						{
							CheckCompletion();
						}
					}

					function CheckCompletion()
					{
						//check if already fixed for reasons unknown
						if(Game_IsTowerActivated("DLC1_TOWER_A")){
							Game_SetWorldState("FIXABLES", "DLC1_TOWER_A", "1");
						}

						local state = Game_GetWorldState("FIXABLES", "DLC1_TOWER_A");					
				
						if (state != null)
						{

							local so_player = Game_GetPrimaryPlayerActor();
							local remark_0 = LOC_TEXT("The link tower was equipped with a [ORANGE]Campfire Triangulation[WHITE] transmitter.");
							local remark_1 = LOC_TEXT("It's broken, but I think It can be replaced. [EMOJI=thinking face]");
							local remark_2 = LOC_TEXT("That should come handy. Maybe it works on those other towers too?");

							Game_AddActorNotificationWithDelay(so_player, remark_0, 3);
							Game_AddActorNotification(so_player, remark_1);
							Game_AddActorNotification(so_player, remark_2);

							Game_SetRecipeUnlocked("TRANSMITTER_CAMP_FAST_TRAVEL", true, true);
							//Game_SetRecipeTracked("TRANSMITTER_CAMP_FAST_TRAVEL", true);

							SetCurrentPhaseGoalCompletedById(id);
						}

					}

				}
			]
		},
		{
			id = "PHASE_ACTIVATIONS"
			description = "[ORANGE]Old Link Tower Activation[WHITE]."
			//reward_string = "???"
			goals = [
				{

					id = "GOAL_ACTIVATE_ANTENNA"
					description = "Activate the [ORANGE]Link Tower[WHITE] at [LOCATION=DLC1_SIGNAL_SOURCE]"
					quest_marker_stage_object_id = "DLC1_TOWER_A"
					actor_id = "DLC1_TOWER_A"

					function OnInitialize()
					{
						local kvs_stage = Stage_GetKeyValueStore();
						KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);

						local linktower = Stage_GetStageObjectById(actor_id);
						if(linktower != null)
						{
							CheckCompletion();
						}
						else
						{
							//Engine_Warning("actor not found");
							return;
						}

					}

					function OnActorInteraction(interactive_actor, interactor_actor, interaction_id)
					{

						if (StageObject_GetId(interactive_actor) == actor_id && interaction_id == "activate")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}

					}

					function CheckCompletion()
					{
						if(Game_IsTowerActivated("DLC1_TOWER_A")){
							SetCurrentPhaseGoalCompletedById(id);
						}

					}

				}
			]
		},
		{
			id = "PHASE_LAST"
			description = "[ORANGE]Endings[WHITE]."
			reward_xp = 2000

			goals = [

				{
					id = "GOAL_INSTALL_TRANSMITTER"
					description = "Craft and Install the [GREEN]Campfire Triangulation[WHITE] transmitter to the [ORANGE]Old Link Tower[WHITE]"

					function OnInitialize()
					{
						local kvs_stage = Stage_GetKeyValueStore();
						KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);
						Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", true);
						Game_SetRecipeUnlocked("TRANSMITTER_CAMP_FAST_TRAVEL", true, false);
						//Game_SetRecipeTracked("TRANSMITTER_CAMP_FAST_TRAVEL", true);
						CheckProgress();
					}
					function OnUpdate(tdelta)
					{
						CheckProgress();
					}
					function CheckProgress()
					{
						local kvs_stage = Stage_GetKeyValueStore();
						KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);

						if (Game_IsRecipeCrafted("TRANSMITTER_CAMP_FAST_TRAVEL")){

							local so_player = Game_GetPrimaryPlayerActor();
							local so = Stage_GetStageObjectById("ivorymountain_relay");
							Actor_InteractWithInteraction(so, so_player, "reactivate")
							SetCurrentPhaseGoalCompletedById(id);

						}

					}

				},
				{
					id = "GOAL_INVESTIGATE"
					description = "Investigate the [LOCATION=DLC1_SIGNAL_SOURCE] building."

					function OnInitialize()
					{
						//Game_SetRecipeUnlocked("TRANSMITTER_CAMP_FAST_TRAVEL", true, true);
						//Game_SetRecipeTracked("TRANSMITTER_CAMP_FAST_TRAVEL", true);
						CheckProgress();

					}
					function OnUpdate(tdelta)
					{
						CheckProgress();
					}
					function CheckProgress()
					{
						local kvs_stage = Stage_GetKeyValueStore();
						KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);

						if(Stage_GetFilename() == "stages/dlc1/index.xml")
							Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", true)
						else
							Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", true)


					}

					function OnCommandWord(command_word)
					{
						if (command_word == "activate")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}
					}


				}

			]
		},
		{
			id = "PHASE_LAST_PORTAL"
			description = "Go through the [ORANGE]Gate of Mist[WHITE] at the Island in the End."
			//reward_recipe_id = "TRANSMITTER_CAMP_FAST_TRAVEL"
			//reward_string = "???"
			reward_xp = 10000

			goals = [
				{
					id = "GOAL_DOORWAY_ENTER"
					description = "[GREEN]Enter[WHITE] the Gate of Mist at the [ORANGE]Island in the End[WHITE]."
					actor_id = "underworld_island_entrance"
					quest_marker_stage_object_id = "underworld_island_entrance"


					function OnInitialize(){
						local kvs_stage = Stage_GetKeyValueStore();
						KeyValueStore_SetKeyValueBoolean(kvs_stage, "always_allow_campfire_fast_travel", false);

						if(Stage_GetFilename() == "stages/dlc1/index.xml")
							Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", true)
						else
							Game_SetFeatureAvailable("CAMPFIRE_FAST_TRAVEL", true)

						local doorway_entrance = Stage_GetStageObjectById("underworld_island_entrance");

						if(doorway_entrance != null){
							local so_player = Game_GetPrimaryPlayerActor();
							Actor_InteractWithInteraction(doorway_entrance, so_player, "init");
						}
					}

					function OnActorInteraction(interactive_actor, interactor_actor, interaction_id){

						 if (StageObject_GetId(interactive_actor) == actor_id && interaction_id == "enter")
						{
							SetCurrentPhaseGoalCompletedById(id);
						}

					}
				}
			]
		}

	]
}


function CheckAllCurrentQuestGoals()
{
	local current_phase_index = Game_GetQuestPhaseIndex(quest_id);
	foreach (goal in quest.phases[current_phase_index].goals)
	{
		if ("CheckCompletion" in goal && goal.CheckCompletion())
		{
			SetCurrentPhaseGoalCompletedById(goal.id);
		}
	}
}

function Initialize()
{
	CheckAllCurrentQuestGoals();
}

function OnCollectedMaterial(so_material, so_collector)
{
	local current_phase_index = Game_GetQuestPhaseIndex(quest_id);
	foreach (goal in quest.phases[current_phase_index].goals)
	{
		if ("CheckCompletion" in goal && goal.CheckCompletion())
		{
			CheckAllCurrentQuestGoals();
		}
	}
}

/*
function OnQuestCompleted()
{
	local text = LOC NOT USED TEXT("[GREEN]Underworld DLC Main Quest[WHITE] is now complete. You can continue completing [GREEN]Side Quests[WHITE] and other activities.");
	text = Game_GetConvertedString(text);
	UI_ShowPopup("", text);

}
*/