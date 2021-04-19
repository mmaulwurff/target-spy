version 4.5

#include "zscript/ts_event_handler.zs"

#include "zscript/m8f_ts_data.zs"
#include "zscript/ts_settings.zs"

#include "zscript/m8f_ts_last_target_info.zs"
#include "zscript/m8f_ts_multi_last_target_info.zs"
#include "zscript/m8f_ts_tag_cache.zs"
#include "zscript/m8f_ts_play_to_ui_translator.zs"

#include "zscript/m8f_ts_string.zs"
#include "zscript/m8f_ts_game.zs"
#include "zscript/m8f_ts_actor_info.zs"

#include "zscript/ts_noblockmap_detection.zs"

// Settings ////////////////////////////////////////////////////////////////////

#include "zscript/settings/m8f_ts_bool_setting.zs"
#include "zscript/settings/m8f_ts_cvar_setting.zs"
#include "zscript/settings/m8f_ts_double_setting.zs"
#include "zscript/settings/m8f_ts_int_setting.zs"
#include "zscript/settings/m8f_ts_string_setting.zs"

// libeye by KeksDose //////////////////////////////////////////////////////////
// https://forum.zdoom.org/viewtopic.php?f=105&t=64566#p1102157

#include "zscript/libeye/ts_projector gl.zs"
#include "zscript/libeye/ts_projector planar.zs"
#include "zscript/libeye/ts_projector.zs"
#include "zscript/libeye/ts_viewport.zs"
