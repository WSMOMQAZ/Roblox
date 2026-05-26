// dear imgui: standalone example application for Android + OpenGL ES 3

#include "imgui.h"
#include "imgui_impl_android.h"
#include "imgui_impl_opengl3.h"

#include <android/log.h>
#include <android_native_app_glue.h>
#include <android/asset_manager.h>

#include <EGL/egl.h>
#include <GLES3/gl3.h>

#include <string>

//====================================================
// 数据
//====================================================

static EGLDisplay           g_EglDisplay = EGL_NO_DISPLAY;
static EGLSurface           g_EglSurface = EGL_NO_SURFACE;
static EGLContext           g_EglContext = EGL_NO_CONTEXT;

static struct android_app*  g_App = nullptr;

static bool                 g_Initialized = false;

static char                 g_LogTag[] = "ImGuiExample";

static std::string          g_IniFilename = "";

//====================================================
// 函数声明
//====================================================

static void Init(struct android_app* app);
static void Shutdown();
static void MainLoopStep();

static int ShowSoftKeyboardInput();
static int PollUnicodeChars();
static int GetAssetData(const char* filename, void** out_data);

//====================================================
// APP 命令
//====================================================

static void handleAppCmd(struct android_app* app, int32_t appCmd)
{
    switch (appCmd)
    {
        case APP_CMD_INIT_WINDOW:
            Init(app);
            break;

        case APP_CMD_TERM_WINDOW:
            Shutdown();
            break;
    }
}

//====================================================
// 输入事件
//====================================================

static int32_t handleInputEvent(struct android_app* app, AInputEvent* inputEvent)
{
    return ImGui_ImplAndroid_HandleInputEvent(inputEvent);
}

//====================================================
// 主入口
//====================================================

void android_main(struct android_app* app)
{
    app->onAppCmd = handleAppCmd;
    app->onInputEvent = handleInputEvent;

    while (true)
    {
        int out_events;
        android_poll_source* out_data;

        while (ALooper_pollOnce(g_Initialized ? 0 : -1,
                                nullptr,
                                &out_events,
                                (void**)&out_data) >= 0)
        {
            if (out_data != nullptr)
                out_data->process(app, out_data);

            if (app->destroyRequested != 0)
            {
                if (!g_Initialized)
                    Shutdown();

                return;
            }
        }

        MainLoopStep();
    }
}

//====================================================
// 初始化
//====================================================

void Init(struct android_app* app)
{
    if (g_Initialized)
        return;

    g_App = app;

    ANativeWindow_acquire(g_App->window);

    //====================================================
    // EGL
    //====================================================

    {
        g_EglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);

        eglInitialize(g_EglDisplay, 0, 0);

        const EGLint egl_attributes[] =
        {
            EGL_BLUE_SIZE, 8,
            EGL_GREEN_SIZE, 8,
            EGL_RED_SIZE, 8,
            EGL_DEPTH_SIZE, 24,
            EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
            EGL_NONE
        };

        EGLint num_configs = 0;

        EGLConfig egl_config;

        eglChooseConfig(
            g_EglDisplay,
            egl_attributes,
            &egl_config,
            1,
            &num_configs
        );

        EGLint egl_format;

        eglGetConfigAttrib(
            g_EglDisplay,
            egl_config,
            EGL_NATIVE_VISUAL_ID,
            &egl_format
        );

        ANativeWindow_setBuffersGeometry(
            g_App->window,
            0,
            0,
            egl_format
        );

        const EGLint egl_context_attributes[] =
        {
            EGL_CONTEXT_CLIENT_VERSION, 3,
            EGL_NONE
        };

        g_EglContext = eglCreateContext(
            g_EglDisplay,
            egl_config,
            EGL_NO_CONTEXT,
            egl_context_attributes
        );

        g_EglSurface = eglCreateWindowSurface(
            g_EglDisplay,
            egl_config,
            g_App->window,
            nullptr
        );

        eglMakeCurrent(
            g_EglDisplay,
            g_EglSurface,
            g_EglSurface,
            g_EglContext
        );
    }

    //====================================================
    // ImGui
    //====================================================

    IMGUI_CHECKVERSION();

    ImGui::CreateContext();

    ImGuiIO& io = ImGui::GetIO();

    // ini
    g_IniFilename =
        std::string(app->activity->internalDataPath)
        + "/imgui.ini";

    io.IniFilename = g_IniFilename.c_str();

    // 风格
    ImGui::StyleColorsDark();

    // 后端
    ImGui_ImplAndroid_Init(g_App->window);

    ImGui_ImplOpenGL3_Init("#version 300 es");

    //====================================================
    // UI 缩放
    //====================================================

    float main_scale = 2.0f;

    ImGuiStyle& style = ImGui::GetStyle();

    style.ScaleAllSizes(main_scale);

    style.FontScaleDpi = main_scale;

    //====================================================
    // 中文字体
    //====================================================

    void* font_data = nullptr;

    int font_data_size = GetAssetData(
        "SourceHanSansCN-Regular.otf",
        &font_data
    );

    ImFont* chinese_font =
        io.Fonts->AddFontFromMemoryTTF(
            font_data,
            font_data_size,
            32.0f,
            NULL,
            io.Fonts->GetGlyphRangesChineseFull()
        );

    IM_ASSERT(chinese_font != nullptr);

    //====================================================

    g_Initialized = true;
}

//====================================================
// 主循环
//====================================================

void MainLoopStep()
{
    ImGuiIO& io = ImGui::GetIO();

    if (g_EglDisplay == EGL_NO_DISPLAY)
        return;

    // Unicode 输入
    PollUnicodeChars();

    // 软键盘
    static bool WantTextInputLast = false;

    if (io.WantTextInput && !WantTextInputLast)
        ShowSoftKeyboardInput();

    WantTextInputLast = io.WantTextInput;

    //====================================================
    // 新帧
    //====================================================

    ImGui_ImplOpenGL3_NewFrame();

    ImGui_ImplAndroid_NewFrame();

    ImGui::NewFrame();

    //====================================================
    // UI
    //====================================================

    {
        static bool check = false;

        static float slider = 50.0f;

        static int counter = 0;

        static char text[256] = "";

        ImGui::Begin("中文测试");

        ImGui::Text("你好世界");

        ImGui::Text("Android ImGui 中文字体");

        ImGui::Checkbox("测试开关", &check);

        ImGui::SliderFloat(
            "测试滑块",
            &slider,
            0.0f,
            100.0f
        );

        ImGui::InputText(
            "输入框",
            text,
            sizeof(text)
        );

        if (ImGui::Button("中文按钮"))
        {
            counter++;
        }

        ImGui::SameLine();

        ImGui::Text("计数: %d", counter);

        ImGui::Text(
            "FPS: %.1f",
            io.Framerate
        );

        ImGui::End();
    }

    //====================================================
    // 渲染
    //====================================================

    ImGui::Render();

    glViewport(
        0,
        0,
        (int)io.DisplaySize.x,
        (int)io.DisplaySize.y
    );

    glClearColor(
        0.1f,
        0.1f,
        0.1f,
        1.0f
    );

    glClear(GL_COLOR_BUFFER_BIT);

    ImGui_ImplOpenGL3_RenderDrawData(
        ImGui::GetDrawData()
    );

    eglSwapBuffers(
        g_EglDisplay,
        g_EglSurface
    );
}

//====================================================
// 关闭
//====================================================

void Shutdown()
{
    if (!g_Initialized)
        return;

    ImGui_ImplOpenGL3_Shutdown();

    ImGui_ImplAndroid_Shutdown();

    ImGui::DestroyContext();

    if (g_EglDisplay != EGL_NO_DISPLAY)
    {
        eglMakeCurrent(
            g_EglDisplay,
            EGL_NO_SURFACE,
            EGL_NO_SURFACE,
            EGL_NO_CONTEXT
        );

        if (g_EglContext != EGL_NO_CONTEXT)
            eglDestroyContext(
                g_EglDisplay,
                g_EglContext
            );

        if (g_EglSurface != EGL_NO_SURFACE)
            eglDestroySurface(
                g_EglDisplay,
                g_EglSurface
            );

        eglTerminate(g_EglDisplay);
    }

    g_EglDisplay = EGL_NO_DISPLAY;
    g_EglContext = EGL_NO_CONTEXT;
    g_EglSurface = EGL_NO_SURFACE;

    ANativeWindow_release(g_App->window);

    g_Initialized = false;
}

//====================================================
// JNI 软键盘
//====================================================

static int ShowSoftKeyboardInput()
{
    JavaVM* java_vm = g_App->activity->vm;

    JNIEnv* java_env = nullptr;

    java_vm->AttachCurrentThread(&java_env, nullptr);

    jclass clazz =
        java_env->GetObjectClass(
            g_App->activity->clazz
        );

    jmethodID method_id =
        java_env->GetMethodID(
            clazz,
            "showSoftInput",
            "()V"
        );

    java_env->CallVoidMethod(
        g_App->activity->clazz,
        method_id
    );

    java_vm->DetachCurrentThread();

    return 0;
}

//====================================================
// Unicode 输入
//====================================================

static int PollUnicodeChars()
{
    JavaVM* java_vm = g_App->activity->vm;

    JNIEnv* java_env = nullptr;

    java_vm->AttachCurrentThread(&java_env, nullptr);

    jclass clazz =
        java_env->GetObjectClass(
            g_App->activity->clazz
        );

    jmethodID method_id =
        java_env->GetMethodID(
            clazz,
            "pollUnicodeChar",
            "()I"
        );

    ImGuiIO& io = ImGui::GetIO();

    jint unicode_character;

    while ((unicode_character =
            java_env->CallIntMethod(
                g_App->activity->clazz,
                method_id
            )) != 0)
    {
        io.AddInputCharacter(unicode_character);
    }

    java_vm->DetachCurrentThread();

    return 0;
}

//====================================================
// 读取 assets
//====================================================

static int GetAssetData(
    const char* filename,
    void** outData
)
{
    int num_bytes = 0;

    AAsset* asset_descriptor =
        AAssetManager_open(
            g_App->activity->assetManager,
            filename,
            AASSET_MODE_BUFFER
        );

    if (asset_descriptor)
    {
        num_bytes =
            AAsset_getLength(asset_descriptor);

        *outData = IM_ALLOC(num_bytes);

        int64_t num_bytes_read =
            AAsset_read(
                asset_descriptor,
                *outData,
                num_bytes
            );

        AAsset_close(asset_descriptor);

        IM_ASSERT(num_bytes_read == num_bytes);
    }

    return num_bytes;
}