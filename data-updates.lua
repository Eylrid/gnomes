function addingtoallrecps(newingname, newingcount)
    --add an ingredient to any recipe that doesn't already have it
    for _, recipe in pairs(data.raw["recipe"]) do
        if recipe.ingredients then
            local ingredients = recipe.ingredients
            addtoitemlist(ingredients, newingname, newingcount)
        end

        if recipe.normal then
            local ingredients = recipe.normal.ingredients
            addtoitemlist(ingredients, newingname, newingcount)
        end

        if recipe.expensive then
            local ingredients = recipe.expensive.ingredients
            addtoitemlist(ingredients, newingname, newingcount)
        end
    end
end

function addtoitemlist(itemlist, newitemname, newitemcount)
    --add {item, count} pair to itemlist
    --if it doesn't already have a pair with item

    --check if new item already in itemlist
    local newitemfound = false
    for _, ing in pairs(itemlist) do
        if ing[1] == newitemname then
            newitemfound = true
        end
    end

    if newitemfound == false then
        --add the ingredient
        itemlist[#itemlist+1] = {newitemname, newitemcount}
    end
end

function addresulttoallrecipes(newprodname, newprodcount)
    --add a product to all recipes that don't have it
    for _, recipe in pairs(data.raw["recipe"]) do
        if recipe.results and recipe.icon then
            addtoitemlist(recipe.results, newprodname, newprodcount)
        elseif recipe.result then
            resulttoresults(recipe)
            if recipe.results then
                addtoitemlist(recipe.results, newprodname, newprodcount)
            end
        end
    end
end

function resulttoresults(recipe)
    --change a recipe defined by a single result to one defined by multiple results
    if not recipe.result_count then
        result_count = 1
    else
        result_count = recipe.result_count
    end
    local result = finditem(recipe.result)

    if result == none then
        result = data.raw["recipe"]["advanced-oil-processing"]
    elseif result.localised_name then
        recipe.localised_name = result.localised_name
    end

    if result["icon"] then
        recipe.icon = result["icon"]
    elseif result["icons"] then
        recipe.icons = result["icons"]
    end

    recipe.icon_size = result.icon_size
    recipe.subgroup = result.subgroup

    recipe.results = {
        {recipe.result, result_count},
    }
end

function finditem(itemname)
    itemtypes = {
        "item",
        "fluid",
        "ammo",
        "capsule",
        "item-with-entity-data",
        "tool",
        "gun",
        "module",
        "armor",
        "rail-planner",
        "repair-tool",
        "spidertron-remote"
    }
    for _, itemtype in pairs(itemtypes) do
        if data.raw[itemtype][itemname] then
            return data.raw[itemtype][itemname]
        end
    end
    --if data.raw["item"][itemname] then
    --    return data.raw["item"][itemname]
    --    --itemtype = "item"
    --elseif data.raw["fluid"][itemname] then
    --    return data.raw["fluid"][itemname]
    --    --itemtype = "fluid"
    --end
    return none
end

--enable all recipes
for _, recipe in pairs(data.raw["recipe"]) do
    recipe.enabled = true
end

--add gnome as an ingredient to any recipe that doesn't already have it
local newingname = "gnome"
local newingcount = 1
addingtoallrecps(newingname, newingcount)

--add tired gnome as a product to any recipe that doesn't already have it
local newprodname = "tired-gnome"
local newprodcount = 1
addresulttoallrecipes(newprodname, newprodcount)
