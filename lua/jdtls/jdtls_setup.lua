local M = {}

function M:setup()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. package.config:sub(1,1) .. "jdtls-workspace" .. package.config:sub(1,1) .. project_name
    local os_name = vim.loop.os_uname().sysname

    local bundles = {
        vim.fn.glob("$MASON/share/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1) -- config java-debug-adapter plugin
    }

    local java_test_bundles = vim.split(vim.fn.glob("$MASON/share/java-test/extension/server/*.jar", 1), "\n") -- configure java-test plugin
    local excluded = {
    "com.microsoft.java.test.runner-jar-with-dependencies.jar",
    "jacocoagent.jar",
    }
    for _, java_test_jar in ipairs(java_test_bundles) do
        local fname = vim.fn.fnamemodify(java_test_jar, ":t")
        if not vim.tbl_contains(excluded, fname) then
            table.insert(bundles, java_test_jar)
        end
    end

    local config = {
        -- The command that starts the language server
        -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
        cmd = {

            -- 💀
            "java", -- or '/path/to/java17_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-javaagent:" .. vim.fn.expand("$MASON/share/jdtls/lombok.jar"),

            -- 💀
            "-jar",
            vim.fn.stdpath("data") .. package.config:sub(1,1) .. "mason" .. package.config:sub(1,1) .. "packages" .. package.config:sub(1,1) .. "jdtls" .. package.config:sub(1,1) .. "plugins" .. package.config:sub(1,1) .. "org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar",
            -- Must point to the                                                     Change this to
            -- eclipse.jdt.ls installation                                           the actual version (located @ ~/.local/share/nvim/mason/share/jdtls/plugins)

            -- 💀
            "-configuration",
            vim.fn.stdpath("data") .. package.config:sub(1,1) .. "mason" .. package.config:sub(1,1) .. "packages" .. package.config:sub(1,1) .. "jdtls" .. package.config:sub(1,1) .. "config_" .. (os_name == "Windows_NT" and "win" or os_name == "Linux" and "linux" or "mac"),
            -- eclipse.jdt.ls installation            Depending on your system.

            -- 💀
            -- See `data directory configuration` section in the README
            "-data",
            workspace_dir,
        },

        -- 💀
        -- This is the default if not provided, you can remove it. Or adjust as needed.
        -- One dedicated LSP server & client will be started per unique root_dir
        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),

        -- Here you can configure eclipse.jdt.ls specific settings
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- for a list of options
        settings = {
            java = {},
        },

        -- Language server `initializationOptions`
        -- You need to extend the `bundles` with paths to jar files
        -- if you want to use additional eclipse.jdt.ls plugins.
        --
        -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
        --
        -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
        init_options = {
            bundles = bundles
        },
    }
    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    require("jdtls").start_or_attach(config)
end

return M
