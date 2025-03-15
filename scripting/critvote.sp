//Includes:
#include <sourcemod>

#define PLUGIN_VERSION "1.0.0"

new bool:firstclientconnected = false

public Plugin:myinfo = 
{
	name = "TF2 Critvote",
	author = "R-Hehl",
	description = "TF2 Critvote",
	version = PLUGIN_VERSION,
	url = "http://HLPortal.de"
};
public OnPluginStart()
{
	CreateConVar("sm_tf2_critvote_version", PLUGIN_VERSION, "TF2 Critvote", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
}
public OnMapStart()
{
	firstclientconnected = false
}
public OnClientPostAdminCheck()
{
	if (!firstclientconnected)
	{
	CreateTimer(30.0, StartVote)
	firstclientconnected = true
	}
}
public Action:StartVote(Handle:timer)
{
	DoVoteMenu()
}

public Handle_VoteMenu(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_End)
	{
		/* This is called after VoteEnd */
		CloseHandle(menu);
	} else if (action == MenuAction_VoteEnd) {
		/* 0=yes, 1=no */
		if (param1 == 0)
		{
			ServerCommand("tf_weapon_criticals 0");
			PrintToChatAll("\x04[\x03TF2-Critvote\x04]\x01 随机暴击已禁用")
		}
		else
		{
			PrintToChatAll("\x04[\x03TF2-Critvote\x04]\x01 随机暴击已启用")
			ServerCommand("tf_weapon_criticals 1");
		}
	}
}
 
DoVoteMenu()
{
	if (IsVoteInProgress())
	{
		return;
	}
 
	new Handle:menu = CreateMenu(Handle_VoteMenu)
	SetMenuTitle(menu, "是否禁用随机暴击?")
	AddMenuItem(menu, "yes", "是")
	AddMenuItem(menu, "no", "否")
	SetMenuExitButton(menu, false)
	VoteMenuToAll(menu, 20);
}
