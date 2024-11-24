return function(initial_message, inputs)
  local function get_git_branch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    local branch = ""
    if handle ~= nil then
      branch = handle:read("*a")
      handle:close()
    end

    branch = branch:gsub("%s+", "") -- Удаление пробелов
 -- Извлечение части строки после последнего символа '/'
    local last_slash_index = branch:find("/") -- Найти индекс последнего '/'
    if last_slash_index then
        -- Вернуть часть строки после последнего '/'
        return branch:sub(#branch - last_slash_index + 2) -- +2, чтобы пропустить '/'
    else
        return branch -- Если '/' нет, вернуть всё имя ветки
    end
  end

  -- Пример вызова функции
  print("Текущая ветка: " .. get_git_branch())
  local scope = inputs.scope
  local msg = inputs.msg
  local commit_message = initial_message
  local branch_name = get_git_branch()
  if scope ~= nil and scope ~= "" then
    commit_message = commit_message .. string.format(": %s [%s]",branch_name, scope)
  end
  commit_message = string.format("%s %s", commit_message, msg)
  return commit_message
end
