
module JamesPlots

using CairoMakie
using ColorSchemes
using Colors

# https://github.com/OrdnanceSurvey/GeoDataViz-Toolkit/tree/master/Colours
const COLORS = ColorScheme(parse.(Colorant, ["#ff1f5b", "#00cd6c", "#009ade", "#af58ba", "#ffc61e", "#f28522"]))
const COLUMN_WIDTH = 240
const TWO_COLUMN_WIDTH = 481
const RESOLUTION = (COLUMN_WIDTH, COLUMN_WIDTH/MathConstants.golden)

const NICECOLORS = ColorScheme(parse.(Colorant, ["#FCE1A4","#FABF7B","#F08F6E","#E05C5C","#D12959","#AB1866","#6E005F"]))
const DIVERGINGCOLORS = ColorScheme(parse.(Colorant,["#045275","#089099","#7CCBA2","#FCDE9C","#F0746E","#DC3977","#7C1D6F"]))

export MyAxis
export save_figure
export COLORS

function MyAxis(f; kwargs...)
    my_ax = Axis(f; kwargs...)

    extra_ax = Axis(f; xaxisposition=:top, yaxisposition=:right, kwargs...)
    linkaxes!(my_ax, extra_ax)
    hidespines!(extra_ax)
    hidedecorations!(extra_ax, ticks=false, minorticks=false)

    return my_ax
end

function choose_color(ncolors)

    selectors = [
        [1],
        [1, 3],
        [1, 3, 5],
        [1, 3, 4, 5],
        [1, 3, 4, 5, 6],
        [1, 2, 3, 4, 5, 6],
    ]
    select = selectors[ncolors]
    return [COLORS[i] for i in select]
end

function get_theme(;scale, ncolors, markersize, fontsize)

    color = choose_color(ncolors)

    Theme(
        resolution=RESOLUTION .* scale,
        figure_padding=1,
        rowgap=0,
        colgap=0,
        fontsize=fontsize,
        fonts=(;regular="Palatino"),
        Axis=(
            xminorticksvisible=true,
            yminorticksvisible=true,
            xgridvisible=false,
            ygridvisible=false,
            xtickalign=1,
            ytickalign=1,
            xminortickalign=1,
            yminortickalign=1,
            spinewidth=scale,
            xtickwidth=scale,
            xminortickwidth=scale,
            ytickwidth=scale,
            yminortickwidth=scale,
            xminorticksize=2scale,
            xticksize=3scale,
            yminorticksize=2scale,
            yticksize=3scale,
            xlabelpadding=scale,
            ylabelpadding=scale,
        ),
        palette=(patchcolor=collect(color), color=color),
        Lines=(
            linewidth=1.5scale,
        ),
        Scatter=(
            strokewidth=0.75scale,
            markersize=markersize*scale
        ),
        Legend=(
            framevisible=true,
            colgap=5scale,
            rowgap=0,
            patchsize=(10scale, 10scale),
            patchlabelgap=3scale,
            padding=(3scale, 3scale, 2scale, 2scale),
            merge=true,
            labelsize=fontsize,
            linewidth=1.5scale,
            markersize=markersize*scale,
            markerstrokewidth=0.75scale,
            titlesize=8scale,
            titlegap=0
        ),
        Colorbar=(
            tickalign=scale,
            ticksize=3scale,
            lip_vertical_label=true
        ),
    )
end

function save_figure(file, plot_function; scale=1, ncolors=3, markersize=3.5, fontsize=10)
    theme = get_theme(;scale, ncolors, markersize, fontsize)
    with_theme(theme) do 
        save(file, plot_function(); px_per_unit=4, pt_per_unit=1)
    end
end

end
