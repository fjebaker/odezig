const std = @import("std");
const solvers = @import("./solvers.zig");
const Solver = solvers.Solver;

pub fn Newton(comptime T: type, comptime N: usize, comptime P: type) type {
    return struct {
        const Self = @This();
        const SolverType = Solver(T, N);
        const U = SolverType.U;
        const ProbFn = solvers.ProbFnType(T, N, P);

        prob: *const ProbFn,
        params: P,

        pub fn init(comptime prob: *const ProbFn, params: P) Self {
            return .{ .prob = prob, .params = params };
        }

        pub fn solver(self: *Self, allocator: std.mem.Allocator) SolverType {
            return SolverType.init(self, Self.step, allocator);
        }

        pub fn step(self: *Self, uprev: *U, t: T, dt: T) !T {
            var du: U = .{@as(T, 0.0)} ** N;
            self.prob(&du, uprev, t, &self.params);
            // update previous
            for (uprev) |*u, i| {
                u.* = u.* + dt * du[i];
            }

            return dt;
        }
    };
}
