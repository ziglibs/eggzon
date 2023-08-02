const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ptk_dep = b.dependency("parser-toolkit", .{});
    const ptk_mod = ptk_dep.module("parser-toolkit");

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    main_tests.addModule("parser-toolkit", ptk_mod);

    const run_main_tests = b.addRunArtifact(main_tests);

    b.getInstallStep().dependOn(&run_main_tests.step);
}
