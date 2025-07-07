# Interop Nuget Package

A simple, automated way to wrap any COM/native DLL as a NuGet package.

## Overview

This template provides a hasslefree approach to package any COM or native DLL with properly configured interop assemblies. 
You get:

* Both reference (`ref/`) and implementation (`lib/`) assemblies
* Automatic wiring of COM import settings (`EmbedInteropTypes`, `CopyLocal`, etc.)
* Compatibility with .NET Framework, .NET Core, .NET 5+, .NET Standard, .NET 8+, and more
* A repeatable MSBuild based workflow that saves hours of manual packaging, testing, and debugging

**Example**: Ships with a StdOle interop DLL by default—but you can swap in any COM/native DLL in minutes.

---

## Installation

### Build Nuget Package

```bash
nuget spec "filename.dll"
```
```bash
nuget pack "filename.nuspec"
```
```bash
build.bat
```

Publish to your private or public NuGet feed.

### Reference in your project

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="your_dll_interop" Version="1.0.0" />
  </ItemGroup>
</Project>
```

Then build—MSBuild auto‑imports `build/*.props` and `build/*.targets`.

---

## Package Structure

```
/ build
  ├─ your_dll_interop.props
  └─ your_dll_interop.targets
/ ref
  └─ net8.0
      └─ your_dll_interop.dll
/ lib
  └─ net8.0
      └─ your_dll_interop.dll
/ packages
  └─ your_dll_interop.1.0.0.nupkg
```

* **build/\*.props**: Injects COM interop settings
* **build/\*.targets**: Ensures runtime DLL deployment
* **ref/**: Compile‑time reference assembly
* **lib/**: Runtime interop assembly
* **packages/**: The generated `.nupkg`

---

## Supported Target Frameworks

* **.NET Framework**: `net461`, `net48`, etc.
* **.NET Core**: `netcoreapp3.1`
* **.NET 5 / 6 / 7 / 8**: `net5.0`, `net6.0`, `net7.0`, `net8.0`
* **.NET Standard**: `netstandard2.0`, `netstandard2.1`

> To add more TFMs, simply add another `<group>` in the `<dependencies>` section of the `.nuspec`.

---

## Usage

### Import Namespaces

```csharp
using StdOle;    // or your own COM namespace
```

### Compile & Run

* **Compile** uses `ref/` for type info
* **Runtime** uses `lib/` for actual native calls
* No manual `<HintPath>` or DLL copy needed!

---

## Customization

1. Replace `your_dll_interop.dll` with your DLL.
2. Edit `your_dll_interop.nuspec` metadata (`<id>`, `<title>`, `<version>`, `<description>`).
3. Adjust target frameworks under `<dependencies><group>`.
4. Simply execute 'build.bat' on a cmd

---

## Benefits

* **Zero Manual Configuration**: Autosets `EmbedInteropTypes`, `PrivateAssets`, copy rules, etc.
* **Multi Targeting**: One package for all your TFMs.
* **Time Savings**: Avoid days of trial and error interop packaging.

---

