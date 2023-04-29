local lfs = require("lfs")
local debug = false

function lookup_metadata(path)
    if debug then print("Checking directory:", path) end
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local file_path = path.."/"..file
            local attributes = lfs.attributes(file_path)
            if attributes.mode == "directory" then
                if debug then print("Checking sub-directory:", file_path) end
                if file:sub(1, 1) ~= "." then
                    local metadata = lookup_metadata(file_path)
                    if metadata then
                        return metadata
                    end
                end
            elseif file:upper() == "FSTER" or file:upper() == "FSTERFILE" then
                print("Checking Fster metadata..")
                if debug then print(file) end
                local f = io.open(file_path, "r")
                if not f then
                    print("Failed while checking metadata. Cannot open the file.")
                    os.exit(1)
                end
                local metadata = f:read("*a")
                f:close()
                return metadata
            end
        end
    end
    return nil
end

return {
  lookup_metadata = lookup_metadata
}
