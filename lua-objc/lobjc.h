#ifndef _LUAOBJC_H
#define _LUAOBJC_H

struct lua_State;

/* open lobjc lib */
int luaopen_objc(struct lua_State* L);

#if defined(__OBJC__)

/* push a NSObject into the stack: Lua will retain its owenership */
int lobjc_pushobject(struct lua_State *, id);

/* get a NSObject at index of the stack */
id lobjc_toobject(struct lua_State*, int);

/* test if a value at index is a NSObject */
int lobjc_isobject(struct lua_State*, int);

#endif

#endif
