local http_request = require "http.request"
local file_download = require "file_download"
local cache = require "cache"

function github_repo_exists(repo_name)
  local url = "https://api.github.com/repos/"..repo_name
  local headers = assert(http_request.new_from_uri(url):go())
  local http_code = tonumber(headers:get(":status"))
  if http_code ~= 200 then
    return false
  end
  return true
end

function get_repo(repo_name)
  local output_name = string.gsub(repo_name, "/", "_").."-"..cache.random_string()..".tar.gz"
  local actual_repo_url = "https://github.com/"..repo_name.."/archive/main.tar.gz"

  print("Checking the repo.. "..repo_name)
  if not github_repo_exists(repo_name) then
    print("This is not a valid GitHub repository. ( ._.)")
    os.exit(1)
  end

  file_download.file_download(actual_repo_url, cache.cache_dir(), output_name)
  return output_name
end

return {
  github_repo_exists = github_repo_exists,
  get_repo = get_repo
}
