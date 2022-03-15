
module JamesPlots

using CairoMakie

const COLUMN_WIDTH = 240
const TWO_COLUMN_WIDTH = 481
const RESOLUTION = (COLUMN_WIDTH, COLUMN_WIDTH/MathConstants.golden)

export MyAxis
export save_figure

function MyAxis(f; kwargs...)
    my_ax = Axis(f; kwargs...)

    extra_ax = Axis(f; xaxisposition=:top, yaxisposition=:right, kwargs...)
    linkaxes!(my_ax, extra_ax)
    hidespines!(extra_ax)
    hidedecorations!(extra_ax, ticks=false, minorticks=false)

    return my_ax
end

function choose_color(ncolors)
    # https://github.com/OrdnanceSurvey/GeoDataViz-Toolkit/tree/master/Colours
    colors = ["#ff1f5b", "#00cd6c", "#009ade", "#af58ba", "#ffc61e", "#f28522"]

    selectors = [
        [1],
        [1, 3],
        [1, 3, 5],
        [1, 3, 4, 5],
        [1, 3, 4, 5, 6],
        [1, 2, 3, 4, 5, 6],
    ]
    select = selectors[ncolors]
    return [colors[i] for i in select]
end

function get_theme(width; ncolors=5)

    color = choose_color(ncolors)

    Theme(
        resolution=RESOLUTION .* width,
        figure_padding=1,
        rowgap=0,
        colgap=0,
        font="Times New Roman", fontsize=8 * width,
        Axis=(
            xminorticksvisible=true,
            yminorticksvisible=true,
            xgridvisible=false,
            ygridvisible=false,
            xtickalign=1,
            ytickalign=1,
            xminortickalign=1,
            yminortickalign=1,
            spinewidth=width,
            xtickwidth=width,
            xminortickwidth=width,
            ytickwidth=width,
            yminortickwidth=width,
            xminorticksize=2width,
            xticksize=3width,
            yminorticksize=2width,
            yticksize=3width,
        ),
        palette=(patchcolor=collect(color), color=color),
        Lines = (
            linewidth=1.5width,
        ),
        Scatter =(
            strokewidth=width,
            markersize=4width
        ),
    )
end

const PUBLICATION_THEME = get_theme(1)
const VIEW_THEME = get_theme(2)

function __init__()
    set_theme!(VIEW_THEME)
end

function save_figure(file, plot_function)
    with_theme(PUBLICATION_THEME) do 
        save(file, plot_function(); pt_per_unit=1)
    end
end

end
