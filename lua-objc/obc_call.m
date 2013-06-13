#import <ffi.h>
#import <lua.h>
#import <lauxlib.h>

#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>

LUA_API int objc_call(lua_State* L);

static int number_of_args(char const* sig){
    return 0;
}

static int sig2ffitype(char const* sig, ffi_type** type){
    return 0;
}

static int sig2number(char const* sig, size_t* size){
    return 0;
}

static void lua2ffi(lua_State* L, int stack, char const* sig, char *mem, size_t size){
    
}

int objc_call(lua_State* L){
    id obj = *(id*) lua_touserdata(L, 1);
    SEL cmd = *(SEL*) lua_touserdata(L, 2);
    Method method = class_getInstanceMethod([obj class], cmd);
    char const* sig = method_getTypeEncoding(method);

    ffi_type *arg_types[16], *ret_type; // todo: more than 16 args?
    ffi_status status;
    void *arg_values[16];
    void *result;

    const char* t=sig;
    size_t next = 0, offset = 0;
    int n = -1, curv = 0;
    t += sig2ffitype(t, &ret_type);     // return type: todo: result size
    
    size_t frSize = 0;
    t += sig2number(t, &frSize);        // call stack size
    
    char *args = malloc(frSize);

    char const* ffi_t = t;
    t += sig2ffitype(t, &arg_types[++n]);   // first arg
    t += sig2number(t, &offset);            // 0
    do{
        arg_values[curv ++] = args + offset;
        lua2ffi(L, curv, ffi_t, args + offset, (next == 0 ? frSize : next)- offset);
        offset = next;

        if(next == 0)
            break;
        
        ffi_t = t;
        t += sig2ffitype(t, &arg_types[++n]);   // next arg
        t += sig2number(t, &next);              // s
    }while (t != NULL);
    
    typedef void (*ffi_fn)(void);
    ffi_fn fn = FFI_FN(objc_msgSend);   // todo: objc_msgSend_stret/objc_msgSend_fpret
    
    ffi_cif cif;
    if ((status = ffi_prep_cif(&cif, FFI_DEFAULT_ABI,
                               n, ret_type, arg_types)) != FFI_OK)
    {
        // Handle the ffi_status error.
    }

    ffi_call(&cif, fn, result, arg_values);
    free(args);
    
    // todo: push back the result
    return 0;
}