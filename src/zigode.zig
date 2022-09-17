const std = @import("std");
const testing = std.testing;


const NoParams = struct{};

const solver = @import("./solver.zig");
const newton = @import("./newton.zig");

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn probFunc(du: *[1] f32, u: *const[1]f32, _: f32, _:*NoParams) void {
    std.debug.print("u = {}\n", .{u[0]});
    du[0] = 4.0; 
}

test "basic functionality" {
    var prob = newton.Newton(f32, 1, NoParams).init(probFunc, .{});
    var solv = newt.getSolver();
    const test_allocator = std.testing.allocator;

    var u: [1]f32 = .{0.0};
    var solution = try solv.solve(
        test_allocator, u, 0.0, 100.0, .{}
    );
    defer solution.deinit();
}