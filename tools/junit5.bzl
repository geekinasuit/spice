"""
Provides JUnit5 support for running kotlin tests.

This is a shim until rules_kotlin supports JUnit 5.
"""

load("@rules_java//java:defs.bzl", "java_test")
load("@rules_kotlin//kotlin:jvm.bzl", "kt_jvm_library")

def kt_jvm_test(name, test_class, data = [], main_class = "", friends = [], size = "medium", **kwargs):
    kt_jvm_library(
        name = name + "_kt_lib",
        testonly = True,
        associates = friends,
        **kwargs
    )

    pkg, _, _ = test_class.rpartition(".")

    java_test(
        name = name,
        use_testrunner = False,
        main_class = "org.junit.platform.console.ConsoleLauncher",
        data = data,
        size = size,
        args = ["--select-package", pkg, "--disable-banner", "--fail-if-no-tests", "--disable-ansi-colors", "--details", "summary"],
        runtime_deps = [
            "@maven//:org_junit_jupiter_junit_jupiter_api",
            "@maven//:org_junit_jupiter_junit_jupiter_engine",
            "@maven//:org_junit_platform_junit_platform_commons",
            "@maven//:org_junit_platform_junit_platform_console",
            "@maven//:org_junit_platform_junit_platform_engine",
            "@maven//:org_junit_platform_junit_platform_launcher",
            ":" + name + "_kt_lib",
        ],
    )
