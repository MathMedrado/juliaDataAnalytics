module App
# set up Genie development environment
using DataFrames
using GenieFramework
using SQLite

@genietools


# add reactive code to make the UI interactive 
@app begin
    # reactive variables are tagged with @in and @out
    @in continent_selection = [""]
    @in date = RangeData(1950:2021)

    @out continent_list = ["", "Asia", "Africa","America","Europia","Oceania"]
    @out plotgraph = PlotData[]

    # watch a variable and execute a block of code when
    # its value changes
    @onchange continent_selection, date begin 
        # the values of result and msg in the UI will
        # be automatically updated

        @show date
        @show continent_selection

        #connection to the database
        db = SQLite.DB("sqlite.db")
        conn = DBInterface

        #read data and Plot
        df = DataFrame(conn.execute(db, "SELECT * FROM population WHERE Continent = '$(uppercase(continent_selection[]))'"))
        plotgraph = [PlotData(x = date.range[1]:date.range[end], y = df.Population.*1000, name = continent_selection[])]
    end
end

# register a new route and the page that will be
# loaded on access
@page("/", "app.jl.html")
end
