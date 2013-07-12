#include <lua.h>
#include <lauxlib.h>

#include "lobjc.h"

/* open lobjc lib */
int luaopen_lobjc(lua_State* L) {
    luaL_Reg entris[] = {
        {"selector",lobjc_pushselector},
        {"class",lobjc_pushclass},
        {NULL, NULL}
    };
    
    luaL_register(L, "lobjc", entris);

    return 1;
}