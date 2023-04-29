function cache_dir(prog_name)
  prog_name = prog_name or "fster"
  local cache_dir = os.getenv("XDG_CACHE_HOME")
  if not cache_dir then
    cache_dir = os.getenv("HOME").."/.cache"
  end
  return cache_dir.."/"..prog_name.."/"
end

function random_string(times)
  times = times or 32
  local result = ""
  for _ = times,1,-1 do result = result..string.char(math.random(65, 65 + 25)):lower() end
  return result
end

return {
  cache_dir = cache_dir,
  random_string = random_string
}