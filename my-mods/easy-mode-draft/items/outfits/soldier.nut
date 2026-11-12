local so_owner = 0;

function OnMetadataRead()
{
	local info = {
		name = "Soldier"
		description = "Military uniform of unknown origin. Excellent for combat situations."
		destroy_after_owner_death = true
	};

	return info;
}

function OnModifiersRead()
{
	local modifiers = {
		additional_item_uses_increase_for_tag_THROWABLE_WEAPON = 2.0
		ranged_damage_percentage_increase_with_damage_type_PIERCING = 80.0
		damage_reduction_percentage_increase = 60.0		
	};

	return modifiers;
}

function OnInitialize(so_handle_owner, item_id)
{
	so_owner = so_handle_owner;
	return true;
}

function OnEquipped()
{
	Actor_SwitchModel(so_owner, "models/outfits/soldier.model");
}

function OnUnequipped()
{
}
