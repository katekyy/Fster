local lfs = require "lfs"

function unpack_tar_gz(filename, output_dir)
  if not lfs.attributes(output_dir, "mode") then
      lfs.mkdir(output_dir)
  end
  os.execute("tar -xzf " .. filename .. " -C " .. output_dir)
end

function file_exists(filename)
  local file = io.open(filename, "rb")
  if file then
    file:close()
    return true
  end
  return false
end

function remove_directory(path)
  for file in io.popen("ls -a \""..path.."\""):lines() do
    if file ~= "." and file ~= ".." then
      local file_path = path.."/"..file
      local attributes = lfs.attributes(file_path)
      if attributes.mode == "directory" then
        remove_directory(file_path)
      else
        os.remove(file_path)
      end
    end
  end
  os.remove(path)
end

function look_for(name, path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local file_path = path.."/"..file
            local attributes = lfs.attributes(file_path)
            if attributes.mode == "directory" then
                if file:sub(1, 1) ~= "." then
                    local target = look_for(name, file_path)
                    if target then
                        return target
                    end
                end
            elseif file:upper() == name:upper() then
                return file_path
            end
        end
    end
end

return {
  unpack_tar_gz = unpack_tar_gz,
  remove_directory = remove_directory,
  file_exists = file_exists,
  look_for = look_for
}
