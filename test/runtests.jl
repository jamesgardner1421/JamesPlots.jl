using JamesPlots
using Test
using CairoMakie

function create_plot()
    fig = Figure()
    ax = MyAxis(fig[1,1], xlabel="numbers", ylabel="more numbers")
    a = rand(100)
    lines!(ax, a)
    scatter!(ax, a)
    b = rand(100)
    lines!(ax, b)
    scatter!(ax, b)
    fig
end

save_figure(joinpath(@__DIR__, "test.pdf"), create_plot)
