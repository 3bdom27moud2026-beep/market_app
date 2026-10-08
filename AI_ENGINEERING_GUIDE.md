# AI Engineering Guide & Canonical Source of Truth

> **CRITICAL MANDATE FOR AI AGENTS**: Read `AI_ENGINEERING_GUIDE.md` completely before making any changes. Treat it as the absolute source of truth. Follow every rule in this document unless explicitly instructed otherwise.

---

## 🏛️ 1. Project Architecture

The Market App follows **Clean Architecture** organized with a **Feature-First** layout.

### Control Flow & Layer Boundaries

$$\text{Presentation (UI)} \longrightarrow \text{Cubit} \longrightarrow \text{UseCase} \longrightarrow \text{Repository} \longrightarrow \text{DataSource} \longrightarrow \text{ApiClient}$$

- **UI (Presentation)**: Renders UI and reacts to Cubit states. **Never** calls APIs, Repositories, or `CacheHelper` directly.
- **Cubit / Bloc**: Manages state using immutable states extending `Equatable`.
- **UseCase (Domain)**: Encapsulates pure, single-responsibility business logic.
- **Repository (Domain/Data)**: Defines abstract interface in `domain/` and implementation in `data/`. Converts Data Models to Domain Entities. Returns `Either<Failure/String, T>`.
- **DataSource (Data)**: 
  - `RemoteDataSource`: Handles API requests via `ApiClient`.
  - `LocalDataSource`: Handles caching/persistence via `CacheHelper` or memory.
- **ApiClient (Core)**: Single wrapper around `Dio` with base options, headers, and interceptors.

---

## 📁 2. Standard Folder Structure

Every feature module inside `lib/features/` **must** adhere to this canonical layout:

```
lib/features/[feature_name]/
├── data/
│   ├── datasource/
│   │   ├── local/                  # Local persistence & caching
│   │   └── remote/                 # API calls via ApiClient
│   ├── models/                     # Data models (extend domain entities, JSON mappers)
│   └── repository/                 # Concrete repository implementations
├── domain/
│   ├── entities/                   # Pure domain business models (Equatable)
│   ├── repository/                 # Abstract repository interfaces
│   └── usecases/                   # Single-responsibility use cases
├── presentation/
│   ├── cubit/                      # Cubit and State definitions
│   ├── pages/ (or screens/)        # Full-screen Flutter views
│   └── widgets/                    # Feature-specific reusable widgets
└── dependency_injection.dart       # Static/GetIt feature dependency factory
```

Core infrastructure is housed in `lib/core/`:
- `animations/`, `constants/`, `di/`, `error/`, `extensions/`, `routes/`, `theme/`, `utils/`, `widgets/`.

---

## ✍️ 3. Coding Conventions & Best Practices

- **Performance**: Use `const` constructors whenever possible.
- **Immutability**: All states and entities must be `immutable` (`final` fields, `const` constructors, `copyWith` pattern).
- **Equality**: All states and entities extend `Equatable` and override `props`.
- **DRY (Don't Repeat Yourself)**: Reuse existing widgets from `lib/core/widgets/` and design system tokens. Do not duplicate logic.
- **RTL & Localization**: All user-facing strings must support Arabic/RTL layouts and localization.
- **UI State Coverage**: Every view/screen must handle 4 states:
  1. 🔄 **Loading** (Shimmer / Loading spinners)
  2. ⚠️ **Error** (Error banners / Retry buttons)
  3. 📦 **Empty** (Empty state placeholders)
  4. ✅ **Success** (Data populated view)

---

## 🎨 4. Design System Tokens

Never hardcode colors, padding, radiuses, or text styles. Always use design system tokens:

- **Colors**: `AppColors` (e.g. `AppColors.primary`, `AppColors.accentGreen`, `AppColors.textDark`). No raw `Color(0xFF...)` or `Colors.red`.
- **Spacing & Padding**: `AppSpacing` (e.g. `AppSpacing.xs`, `AppSpacing.md`, `AppSpacing.lg`) and spacing extensions (e.g. `12.hSpace`, `16.vSpace`).
- **Border Radius**: `AppRadius` (e.g. `AppRadius.sm`, `AppRadius.md`, `AppRadius.lg`).
- **Typography**: `AppTextStyles` presets (e.g. `AppTextStyles.headingMedium`, `AppTextStyles.bodyMedium`).
- **Shadows**: `AppShadows` presets.

---

## 🔒 5. Business Rules & Authentication Guard

- **Auth Source of Truth**: Authentication flow is guarded **exclusively** through `AuthHelper.ensureAuthenticated(context, onAuthenticated: ...)`.
- **No Direct Cache Access**: UI and Cubits must **never** inspect `CacheHelper` directly for auth tokens or user sessions.
- **Automatic Retry Pattern**:
  $$\text{AuthHelper.ensureAuthenticated} \longrightarrow \text{Register/Login Dialog} \longrightarrow \text{Automatic Retry of original action on success}$$

---

## 🌐 6. API Contracts & Networking Rules

- **HTTP Client**: Always use `ApiClient`. **Never** use `Dio` directly outside `ApiClient`, and **never** use the `http` package.
- **Data Encapsulation**: 
  - Raw JSON is parsed inside DataSources/Models (`Model.fromJson`).
  - Raw JSON/Maps must **never** leak outside the Data layer.
  - Repositories return Domain Entities.
- **Error Handling**: Standardized handling for HTTP status codes:
  - `400 Bad Request`
  - `401 Unauthorized`
  - `403 Forbidden`
  - `404 Not Found`
  - `422 Validation Error`
  - `500 Internal Server Error`
  - Connection timeouts & network offline failures.

---

## 💉 7. Dependency Injection Rules

- **Registration Chain**: Every new layer class requiring injection **must** be registered in `GetIt` or feature `dependency_injection.dart`:
  1. `RemoteDataSource` & `LocalDataSource`
  2. `RepositoryImpl` (registered as abstract `Repository`)
  3. `UseCase`
  4. `Cubit`
- **No Manual Instantiation**: Never manually instantiate repositories or data sources inside UI or Cubits. Retrieve them via the DI container.

---

## 🧪 8. Testing & Analysis Standards

- **Static Analysis**: Run `flutter analyze` after all code modifications to ensure 0 errors and 0 warnings.
- **Unit & Widget Testing**: Maintain and update test suites in `test/` whenever modifying features or use cases.
- **Regression Prevention**: Never break existing working code or change public API signatures without backward compatibility.

---

## 📋 9. Implementation Protocol & Workflow

### 4-Phase Task Execution Workflow

1. **🔍 Analysis**: Survey existing code, affected files, and potential risks across the entire project.
2. **📝 Implementation Plan**: Outline concrete architectural steps.
3. **💻 Code Changes**: Execute edits respecting design system tokens and clean architecture boundaries.
4. **✅ Verification**: Run `flutter analyze`, `flutter test`, and provide manual verification steps.

### 10-Point Definition of Done Checklist

- [ ] Project compiles cleanly.
- [ ] Imports cleaned and sorted.
- [ ] Dependency injection updated.
- [ ] AppRouter and AppRoutes updated (if navigation involved).
- [ ] Localization and RTL supported.
- [ ] No duplicated code or magic numbers.
- [ ] No architecture violations (Strict presentation $\rightarrow$ cubit $\rightarrow$ usecase $\rightarrow$ repository $\rightarrow$ datasource $\rightarrow$ apiClient).
- [ ] No dead or unused code.
- [ ] Tests updated.
- [ ] Existing working functionality strictly preserved.
