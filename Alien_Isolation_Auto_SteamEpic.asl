// Alien: Isolation (PC, Steam, Epic) autosplitter & load remover
// Autosplitter by Cliffs
// Load remover by Fatalis
// Modified by Coockie1173 to allow Epic Games version

state("AI", "Steam")
{
	int fadeState : 0x15D24B4;
	float fadeNum : 0x15D24B8;
	byte gameFlowState : 0x12F0C88, 0x48, 0x8;
	int levelManagerState : 0x12F0C88, 0x3C, 0x4C;
	byte loadingIcon : 0x134A7D0, 0x1D;
	int missionNum : 0x17E4814, 0x4, 0x4E8;
}

state("AI", "Epic")
{
	int fadeState : 0x15E2664;
	float fadeNum : 0x15E2668;
	byte gameFlowState : 0x012526BC, 0x8;
	int levelManagerState : 0x0130D30C, 0x68, 0x4C;
	int missionNum : 0x130D1A8, 0x78, 0x10EC;
	byte loadingIcon : 0x01366CAC, 0xF50, 0x1D;
}

startup
{
	vars.loading = false;
	vars.final = false;
	vars.mission = null;
}

init
{
	vars.loading = false;
	vars.final = false;
	
	if(modules.First().ModuleMemorySize == 0x1F9F000)
	{
		version = "Epic";
	}
	else
	{
		version = "Steam";
	}
}

start
{
	vars.loading = false;
	vars.final = false;
	vars.mission = null;
	return current.fadeState == 2 && current.fadeNum > 0 || old.gameFlowState == 6 && current.gameFlowState == 4;
}

update
{	
	if (old.levelManagerState == 5 && current.levelManagerState == 7 || current.gameFlowState == 6)
	{
		vars.loading = true;
	}
	else if (current.fadeState == 2 && old.fadeNum < 0.2 && current.fadeNum > 0.2)
	{
		vars.loading = false;
	}
	if (current.missionNum == 19 && current.fadeState == 2 && old.fadeNum < 0.5 && current.fadeNum > 0.5)
	{
		vars.final = true;
	}
	if (vars.mission == null && current.fadeState == 2 && old.fadeNum < 0.5 && current.fadeNum > 0.5)
	{
		vars.mission = current.missionNum;
	}
}

split
{
	if (vars.mission != null && current.missionNum > vars.mission)
	{
		vars.mission = current.missionNum;
		return true;
	}
	else if (vars.final == true && current.fadeState == 1 && current.gameFlowState == 4)
	{
		vars.final = false;
		return true;
	}
}

isLoading
{
	return vars.loading;
}