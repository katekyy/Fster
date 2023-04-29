local curl = require "cURL"
local lfs = require "lfs"

function file_download(url, dir, output)
  print("Getting the file..")
  output = output or "received.unknown"

  if not lfs.attributes(dir, "mode") then
      lfs.mkdir(dir)
  end

  local file = io.open(dir..output, "w")
  if not file then
    print("Cannot create a file."..dir..output)
    os.exit(1)
  end

  local c = curl.easy_init()
  c:setopt_url(url)
  c:setopt(curl.OPT_FOLLOWLOCATION, true)
  c:perform({
    writefunction = function(str)
      if not str then
        print("Request content is Nil.")
        os.exit(1)
      end
      file:write(str)
    end
  })

  file:close()
  print("Successfully got the file.")
end

return {
	file_download = file_download
}

