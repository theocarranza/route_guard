---
trigger: always_on
---

# Effective Dart Style Guide

## 1. Style Rules (Naming & Formatting)

### Naming Conventions
- **UpperCamelCase**: Types (classes, enums, typedefs), extensions
- **lowerCamelCase**: Members, variables, parameters, constants
- **snake_case**: File names, directories, packages, import prefixes
- **Acronyms**: Capitalize like words (e.g., `HttpConnection` not `HTTPConnection`)

### Formatting
- Always use `dart format`
- Keep lines under 80 characters
- Always use curly braces `{}` for control flow statements

### Import Ordering
1. `dart:` imports first
2. `package:` imports second
3. Relative imports last
4. Sort each section alphabetically

## 2. Documentation Rules

- Use `///` for doc comments (enables dart doc generation)
- Start with a single-sentence summary
- Separate summary from body with blank line
- Use `[ClassName]` to reference identifiers
- Document all public APIs; skip private members unless complex

## 3. Usage Rules

### Null Safety
- Don't initialize to `null` explicitly (`int? count;` not `int? count = null;`)
- Use `late` only when certain initialization happens before first use

### Collections
- Use literals (`[]`, `{}`) instead of constructors
- Use `.isEmpty`/`.isNotEmpty` instead of `.length == 0`
- Use `.map()`, `.where()`, `.toList()` for transformations

### Async
- Prefer `async/await` over `.then()` chains
- Use `Future<void>` for async functions without return values

### Variables
- Use `var` when type is obvious from context
- Avoid `dynamic` unless explicitly disabling type checking

## 4. Design Rules

### Parameters
- Avoid positional booleans; use named parameters for clarity
- Use inclusive start, exclusive end for ranges

### Members
- Use getters for cheap, side-effect-free properties
- Don't define setters without getters
- Make fields `final` when possible

### Equality
- Override `hashCode` when overriding `==`
- Avoid custom equality for mutable classes

### Constructors
- Use `const` constructors when class can be immutable
