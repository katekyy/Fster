local repo = require "repo"
local cache = require "cache"
local myfs = require "myfs"
local meta = require "metadata"
local dkjson = require "dkjson"
local argparse = require "argparse"

local function clear_cache(output_path, tar_out_path)
  os.remove(output_path)
  myfs.remove_directory(tar_out_path)
end

local function pwd()
  local handle = io.popen("pwd")
  if not handle then return nil end
  local current_dir = handle:read("*a")
  handle:close()
  return current_dir
end

-- create an argument parser and define the "repo" argument
local parser = argparse("Fster", "A Github repo based package manager. For Unix..")
parser:argument("repo", "Github repository to install.")
parser:option("--target", "Targets defined in repos Fster file.")
parser:option("--targets", "List available targets.", false, {}, 0)

local args = parser:parse()

if not args.target and not args.targets then
  print("Please specify your target.")
  print("Add \"-h\" for help")
  os.exit(1)
end

local user_input = args.repo
local snake_case_name = string.gsub(user_input, "/", "_")

local output_name = repo.get_repo(user_input)
local output_path = cache.cache_dir() .. output_name

print("Unpacking.. " .. output_name)
local tar_out_path = cache.cache_dir() .. snake_case_name .. "-" .. cache.random_string()
myfs.unpack_tar_gz(output_path, tar_out_path)

-- Checking Fster metadata
local metadata = meta.lookup_metadata(tar_out_path)
if not metadata then
  print("Metadata is Nil.")
  clear_cache(output_path, tar_out_path)
  os.exit(1)
end

local metadata_table = dkjson.decode(metadata)
local script_table = {}

if args.targets then
  print("\nAvailable targets for " .. user_input .. ":")
  for os_name, _ in pairs(metadata_table.scripts) do
    print("  "..os_name)
  end
  os.exit()
end

if args.target and not metadata_table.scripts[args.target] then
  print("Error: target " .. args.target .. " is not defined in the Fster file.")
  os.exit(1)
end

for os_name, scripts in pairs(metadata_table.scripts) do
  if not args.target or args.target == os_name then
    script_table[os_name] = scripts
  end
end

for os_name, scripts in pairs(script_table) do
  print("Resolving scripts for: " .. os_name)
  for i, script in ipairs(scripts) do
    print(i, script)
  end
end

::ask::
io.write("Would you like to proceed? (Y/n): ")
local answer = io.read()
if answer:lower() == "n" then
  print("Okay. Exiting! ( ._.)")
  clear_cache(output_path, tar_out_path)
elseif answer ~= "" and answer:lower() ~= "y" then
  goto ask
end

if not script_table or next(script_table) == nil then
  print("There are no scripts to run!")
  clear_cache(output_path, tar_out_path)
  os.exit()
end

for _, script in ipairs(script_table[args.target] or {}) do
  local script_path = myfs.look_for(script, tar_out_path)
  if io.open(script_path) then
    print("Running script: " .. script)
    os.execute("cd " .. string.match(script_path, "^(.-)[^\\/]*$") .. " && " .. script_path)
  else
    print("Script file not found: " .. script_path)
  end
end

print("Clearing cache..")
clear_cache(output_path, tar_out_path)