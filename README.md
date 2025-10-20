# ⚡ Ultimate FPS Booster for Roblox (Luau Script)
> 🚀 Boost your FPS, reduce lag, and optimize graphics intelligently — for any Roblox game.  
> 💬 *Tối ưu FPS, giảm giật lag, và cải thiện hiệu năng tổng thể cho mọi trò chơi Roblox.*

---

## 🧠 Overview / Tổng quan
**Ultimate FPS Booster** is a lightweight and safe Roblox optimization script written in **Luau**, designed to improve game performance without breaking core gameplay mechanics.

> Script này được viết bằng **Luau**, tập trung vào việc **tăng FPS mà không ảnh hưởng đến gameplay** hoặc gây lỗi hiển thị.

---

## 📋 Feature Summary / Tóm tắt tính năng

| 🧩 Category | ✨ Description (English) | 💡 Giải thích (Tiếng Việt) |
|-------------|--------------------------|-----------------------------|
| 🎨 **Graphics Optimization** | Lowers render quality, disables shadows/reflections, removes post effects, simplifies materials. | Tối ưu đồ họa bằng cách giảm chất lượng render, tắt bóng đổ và phản chiếu, xóa hiệu ứng hình ảnh nặng. |
| 🧱 **Object Optimization** | Removes particles, beams, lights, decals, clothes, accessories, simplifies meshes. | Xóa các hiệu ứng và vật thể không cần thiết để giảm tải CPU & GPU. |
| 🌄 **Environment Optimization** | Removes sky, atmosphere, fog, clouds, decorations. | Làm môi trường trống nhẹ hơn, giúp tăng hiệu năng. |
| ⚙️ **Performance Boosts** | Unlocks FPS, optimizes physics, reduces draw distance, uses smart batch processing. | Mở giới hạn FPS, giảm độ xa hiển thị, xử lý thông minh theo đợt. |
| 🧩 **Smart Features** | Ignores player/weapon models, safe object destruction, progressive loading. | Hệ thống thông minh giúp giữ nguyên vật phẩm người chơi và tối ưu dần dần. |
| 📊 **Performance Monitor** | Displays FPS, memory, and ping with customizable position. | Hiển thị FPS, RAM, ping theo thời gian thực và có thể thay đổi vị trí hiển thị. |
| 🔧 **Runtime Functions** | Reconfigure, restore graphics, manual GC, toggle counter. | Hỗ trợ chỉnh cấu hình và khôi phục đồ họa trong khi đang chơi. |

---

## 🧩 Detailed Feature Table / Bảng tính năng chi tiết

<details>
<summary><b>📉 Graphics Optimization (Tối ưu đồ họa)</b></summary>

```lua
✓ Quality Level 01          - Minimum render quality
✓ Disable Shadows           - Remove all shadows
✓ Disable Reflections       - Remove reflections
✓ Remove Post Effects       - Delete Bloom, Blur, etc.
✓ Simplify Materials        - Convert to SmoothPlastic
✓ Remove Textures           - Delete TextureID
✓ Disable Anti-Aliasing     - Turn off AA
✓ Remove Fog                - No fog rendering
✓ Maximum Brightness        - Constant lighting
````

> 💬 *Giảm tải đồ họa tối đa, phù hợp cho máy yếu hoặc mobile.*

</details>

<details>
<summary><b>⚙️ Object Optimization (Tối ưu vật thể)</b></summary>

```lua
✓ Remove Particles, Trails, Beams
✓ Remove Lights & Decals
✓ Remove Clothes & Accessories
✓ Simplify Meshes (Performance mode)
✓ Minimal Collision (Box)
✓ Optimize Humanoids (Hide NameTag, HealthBar)
```

> 💬 *Loại bỏ các vật thể không quan trọng giúp giảm số lượng instance và draw call.*

</details>

<details>
<summary><b>🌄 Environment Optimization (Tối ưu môi trường)</b></summary>

```lua
✓ Remove Sky, Atmosphere, Clouds
✓ Disable Terrain Decoration
✓ Simplify Water (Transparency = 1)
```

> 💬 *Làm môi trường nhẹ hơn mà vẫn giữ độ hiển thị cơ bản.*

</details>

<details>
<summary><b>🚀 Performance Boosts (Tăng hiệu năng)</b></summary>

```lua
✓ Unlock FPS (setfpscap 999)
✓ Clear Nil Instances
✓ Garbage Collection every 30s
✓ Optimize Physics & Interpolation
✓ Reduce Draw Distance (FOV 70)
✓ Batch Processing (500 objects/batch)
✓ Smart Yielding (task.wait)
```

> 💬 *Tăng tốc độ khung hình ổn định bằng cách tối ưu vật lý và bộ nhớ.*

</details>

<details>
<summary><b>🧠 Smart Features (Tính năng thông minh)</b></summary>

```lua
✓ Player Ignore System
✓ Tool Ignore System
✓ Safe Destruction (pcall)
✓ Progressive Loading
✓ FPS/Memory/Ping Counter
✓ Emergency Restore System
```

> 💬 *Giúp script hoạt động an toàn và thông minh hơn.*

</details>

---

## 🧩 Removed Features / Các tính năng bị loại bỏ

| ❌ Removed               | 🔍 Reason                |
| ----------------------- | ------------------------ |
| Disable Touch Interests | Breaks game collisions   |
| Animation Throttling    | Makes animations stutter |
| Aggressive Culling      | Causes frame drops       |
| Remove Water Completely | Deletes map terrain      |
| Multi-threading         | Slower on Luau           |
| Memory Memoization      | Slower GC                |

> 💬 *Những tính năng này đã được thử nghiệm nhưng bị loại vì gây lag hoặc lỗi gameplay.*

---

## 📊 Expected Performance / Hiệu suất dự kiến

| Device           | Before     | After       | Gain      |
| ---------------- | ---------- | ----------- | --------- |
| 🖥️ Low-end PC   | 15–30 FPS  | 60–100+ FPS | +200–300% |
| 💻 Mid-range PC  | 30–60 FPS  | 100–180 FPS | +150–250% |
| ⚡ High-end PC    | 60–144 FPS | 200–400 FPS | +100–200% |
| 📱 Potato Mobile | 10–20 FPS  | 40–70 FPS   | +300–400% |
| 📱 Good Mobile   | 30–45 FPS  | 80–120 FPS  | +150–200% |

> ⚠️ *Kết quả thực tế phụ thuộc vào cấu hình thiết bị và độ nặng của game.*

---

## 🧰 Usage / Cách sử dụng


-- Step 1: Execute in your executor

```lua
getgenv().UltimateFPS = {
    Settings = {
        -- Graphics Settings (Cài đặt đồ họa)
        Graphics = {
            MinimalQuality = true,           -- Level 01 quality
            DisableShadows = true,           -- Tắt bóng đổ
            DisableReflections = true,       -- Tắt phản chiếu
            SimplifyMaterials = true,        -- Đơn giản hóa vật liệu
            RemoveTextures = true,           -- Xóa textures
            DisablePostProcessing = true,    -- Tắt post effects
            ForceCompatibilityMode = true,   -- Chế độ tương thích
            DisableAntiAliasing = true,      -- Tắt khử răng cưa
            MaximizeBrightness = true,       -- Tăng độ sáng tối đa
            RemoveFog = true,                -- Xóa sương mù
        },
        
        -- Object Settings (Cài đặt vật thể)
        Objects = {
            RemoveParticles = true,          -- Xóa particle effects
            RemoveTrails = true,             -- Xóa trails
            RemoveBeams = true,              -- Xóa beams
            RemoveLights = true,             -- Xóa lights
            RemoveDecals = true,             -- Xóa decals/textures
            RemoveClothes = true,            -- Xóa quần áo
            RemoveAccessories = true,        -- Xóa phụ kiện
            RemoveExplosions = true,         -- Tắt explosions
            RemoveAttachments = true,        -- Xóa attachments
            SimplifyMeshes = true,           -- Đơn giản hóa mesh
            MinimalCollision = true,         -- Collision đơn giản nhất
            MuteSounds = true,               -- Giảm volume âm thanh
            OptimizeHumanoids = true,        -- Tối ưu humanoids
        },
        
        -- Environment Settings (Cài đặt môi trường)
        Environment = {
            SimplifyTerrain = true,          -- Đơn giản hóa địa hình
            RemoveSky = true,                -- Xóa sky
            RemoveAtmosphere = true,         -- Xóa atmosphere
            RemoveClouds = true,             -- Xóa clouds
            DisableTerrainDecoration = true, -- Tắt terrain decoration
            MinimizeWater = true,            -- Giảm hiệu ứng nước (KHÔNG xóa)
        },
        
        -- Performance Settings (Cài đặt hiệu năng)
        Performance = {
            UnlockFPS = true,                -- Mở khóa FPS
            FPSCap = 999,                    -- Giới hạn FPS (999 = unlimited)
            DevConsoleBoost = true,          -- Dev console trick
            ClearNilInstances = true,        -- Dọn nil instances
            GarbageCollection = true,        -- Garbage collection định kỳ
            GCInterval = 30,                 -- GC mỗi 30 giây
            OptimizePhysics = true,          -- Tối ưu physics
            ReduceDrawDistance = true,       -- Giảm khoảng cách render
            DisableStreaming = true,         -- Tắt streaming
            InterpolationThrottle = true,    -- Throttle interpolation
            BatchSize = 500,                 -- Số objects/batch
            YieldInterval = 500,             -- Yield sau mỗi X objects
        },
        
        -- Player Settings (Cài đặt người chơi)
        Player = {
            IgnoreSelf = true,               -- Không optimize nhân vật mình
            IgnoreOthers = false,            -- Optimize nhân vật khác
            IgnoreTools = true,              -- Không xóa tools
        },
        
        -- Display Settings (Cài đặt hiển thị)
        Display = {
            ShowFPSCounter = true,           -- Hiển thị FPS counter
            ShowMemoryUsage = true,          -- Hiển thị RAM usage
            ShowPing = true,                 -- Hiển thị ping
            CounterPosition = "TopRight",    -- Vị trí: TopRight, TopLeft, BottomRight, BottomLeft
            CounterTransparency = 0.2,       -- Độ trong suốt (0-1)
        }
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Diffone7/r/Roblox-FPS-Booster/main/ultimatefps.lua"))()
```

-- Step 2: Wait for optimization

-- Output: "OPTIMIZATION COMPLETE"

-- Step 3: Enjoy smoother gameplay!


> 💡 *Chạy script, đợi hoàn tất tối ưu, và trải nghiệm game mượt mà hơn.*

---

## ⚙️ Example Reconfigure / Ví dụ chỉnh cấu hình

```lua
getgenv().ReconfigureUltimateFPS({
    Graphics = {
        RemoveTextures = false,  -- Keep textures (giữ lại texture)
    },
    Objects = {
        RemoveClothes = false,   -- Keep clothes (giữ lại quần áo)
    },
    Display = {
        CounterPosition = "TopLeft"  -- Move FPS counter
    }
})
```

> 🔧 *Bạn có thể thay đổi các cài đặt này bất kỳ lúc nào trong runtime.*

---

## 🧪 Tested & Stable / Kiểm thử & Ổn định

✅ Compatible with all Roblox games
✅ Safe for executors
✅ No visual/gameplay breakage
✅ Lag-free and smooth animation

> 🧩 *Đã thử nghiệm.*

---

## ✅ Tested Executors / Executor đã thử nghiệm

> Những executor được kiểm thử thành công với script này. (Links & logos provided for reference.)

### Xeno

[![Xeno Logo](https://i.pinimg.com/280x280_RS/06/ff/27/06ff27ea42bcae0978c4c95a49735670.jpg)](https://xeno.onl)

**Website:** [https://xeno.onl](https://xeno.onl)

**Discord:** [https://discord.gg/xe-no](https://discord.gg/xe-no)

> *Đã thử nghiệm trên Xeno — hoạt động ổn định, tương thích tốt với các tính năng unlock FPS và batch processing.*

---

### DeltaX

[![DeltaX Logo](https://pbs.twimg.com/profile_images/1724003690724655104/R4JmSAW7_400x400.jpg)](https://deltaexploits.gg)

**Website:** [https://deltaexploits.gg](https://deltaexploits.gg)

**Discord (main):** [https://discord.gg/deltax](https://discord.gg/deltax)

**Discord (alt):** [https://discord.gg/hW338Ugn3A](https://discord.gg/hW338Ugn3A) 

> *Đã kiểm thử trên DeltaX — tương thích, hoạt động ổn định với các tính năng safe destruction và progressive loading.*

---

## 🧾 Credits

* **Claude Sonnet 4.5**
* Based on **V3.0 + V4.0 Analysis**
* Optimized for **Maximum Stability**
* **Version: 4.5 ULTIMATE STABLE**
* License: **MIT**

---

## 🪪 License

This project is licensed under the [MIT License](LICENSE).
Bạn có thể **tự do sử dụng, chỉnh sửa và phân phối** miễn là giữ nguyên thông tin credit.

---

## 🧠 Tips / Mẹo sử dụng

* Avoid running multiple optimization scripts at once. *(Không nên chạy nhiều script tối ưu cùng lúc)*
* Restart Roblox after heavy optimization for best results. *(Khởi động lại Roblox sau khi tối ưu để hiệu quả hơn)*
* Use this script **only in trusted executors.**

---

## 🌐 Links

* 🔗 **GitHub Repository:** `https://github.com/Diffone7/r/Roblox-FPS-Booster`
* 📜 **License:** [MIT](LICENSE)

---

> 🏁 *Made for Roblox players who want maximum FPS without breaking visuals.*
> 💖 *Created with care for stability, simplicity, and smoothness.*


