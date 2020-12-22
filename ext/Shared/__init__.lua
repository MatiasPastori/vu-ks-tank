print(SharedUtils:GetLevelName())
print("hi")
Events:Subscribe(
    "BundleMounter:GetBundles",
    function(bundles)
        print(SharedUtils:GetLevelName())
        if(SharedUtils:GetLevelName() ~= "Levels/MP_012/MP_012") then
            
        end
       -- if(SharedUtils:GetLevelName() ~= "Levels/MP_012/MP_012") then
        --    Events:Dispatch(
        --    "BundleMounter:LoadBundles",
       --     "Levels/MP_012/MP_012",
        --    {
        --        "Levels/MP_012/MP_012",
       --         "Levels/MP_012/conquest_large"
        --    }
        --)
        --end
        
    end
)
