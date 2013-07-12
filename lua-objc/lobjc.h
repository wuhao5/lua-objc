#ifndef _LUAOBJC_H
#define _LUAOBJC_H

#include <lua.h>

/* open lobjc lib */
int luaopen_lobjc(lua_State*);

// push a selector from a given string
// SEL is stored as a light userdata
int lobjc_pushselector(lua_State*);

// push a class from a given string
// it will retain the ownership just to conform the memory policy
// and itself will still be seen as an "object" (metatable),
// which is the same semantic inside objective-c
int lobjc_pushclass(lua_State*);

// push the metatable for object/class into the stack
void lobjc_objmeta(lua_State*);


#if defined(__OBJC__)

/* push a NSObject into the stack: Lua will retain its owenership */
int lobjc_pushobject(lua_State *, id);

/* get a NSObject at index of the stack */
id lobjc_toobject(lua_State*, int);

/* test if a value at index is a NSObject */
int lobjc_isobject(lua_State*, int);

#endif

#endif
