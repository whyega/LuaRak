#pragma warning(disable : 26495) // Variable '%variable%' is uninitialized. Always initialize a member variable (type.6).
#pragma warning(disable : 26819) // Unannotated fallthrough between switch labels (es.78).
#pragma warning(disable : 26439) // This kind of function may not throw. Declare it 'noexcept'.
#include "sol.hpp"
#pragma warning(default : 26439)
#pragma warning(default : 26819)
#pragma warning(default : 26495)


#include "lua_module.h"
#include "LuaRak.hpp"