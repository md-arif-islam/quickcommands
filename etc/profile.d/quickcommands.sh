# Function to select command and fill readline buffer (only works in key binding context)
_quickcommands_fill_readline() {
  local SAVE_FILE="$HOME/.saved_commands"
  
  # Ensure saved commands file exists with defaults
  if [[ ! -s "$SAVE_FILE" ]]; then
    echo "echo hello" > "$SAVE_FILE"
    echo "whoami" >> "$SAVE_FILE"
  fi
  
  while true; do
    # Create temp files to capture actions
    local temp_save="/tmp/saved_save_$$"
    local temp_delete="/tmp/saved_delete_$$"
    
    # Prepare content - show message if empty
    local content
    if [[ ! -s "$SAVE_FILE" ]]; then
      content="No commands found. Write your first command and press Ctrl+S"
    else
      content="$(cat "$SAVE_FILE")"
    fi
    
    # Use fzf with binds for both Ctrl+S (save) and Ctrl+D (delete)
    local selection
    selection="$(echo "$content" | fzf \
      --prompt="COMMANDS> " \
      --header="Type to search | Enter: FILL | Ctrl+S: SAVE | Ctrl+D: DELETE selected | Ctrl+C: Exit" \
      --bind="ctrl-s:execute-silent(echo {q} > $temp_save)+abort" \
      --bind="ctrl-d:execute-silent(echo {} > $temp_delete)+abort" \
      --no-clear \
      --query='')" || {
      
      # Check if Ctrl+S was pressed (save what you type)
      if [[ -f "$temp_save" ]]; then
        local typed_command=$(cat "$temp_save")
        rm -f "$temp_save"
        
        if [[ -n "$typed_command" ]]; then
          if ! grep -Fxq "$typed_command" "$SAVE_FILE" 2>/dev/null; then
            echo "$typed_command" >> "$SAVE_FILE"
          fi
        fi
        continue
      fi
      
      # Check if Ctrl+D was pressed (delete selected)
      if [[ -f "$temp_delete" ]]; then
        local selected_command=$(cat "$temp_delete")
        rm -f "$temp_delete"
        
        # Don't delete the "no commands" message
        if [[ -n "$selected_command" && "$selected_command" != "No commands found. Write your first command and press Ctrl+S" ]]; then
          # Show delete confirmation in full fzf window
          local confirm_result
          confirm_result="$(echo -e "YES - Delete: $selected_command\nNO - Keep: $selected_command" | fzf \
            --prompt="DELETE> " \
            --header="Are you sure you want to delete this command?" \
            --no-multi \
            --no-clear)" || continue
          
          if [[ "$confirm_result" == "YES - Delete: $selected_command" ]]; then
            # Use a more reliable deletion method
            local temp_file="${SAVE_FILE}.tmp"
            > "$temp_file"  # Create empty temp file
            
            # Copy all lines except the one to delete
            while IFS= read -r line; do
              if [[ "$line" != "$selected_command" ]]; then
                echo "$line" >> "$temp_file"
              fi
            done < "$SAVE_FILE"
            
            mv "$temp_file" "$SAVE_FILE"
          fi
        fi
        continue
      fi
      
      # Normal exit (Ctrl+C or Escape)
      return 0
    }
    
    # Normal selection - fill readline buffer (but not the "no commands" message)  
    if [[ -n "$selection" && "$selection" != "No commands found. Write your first command and press Ctrl+S" ]]; then
      # This only works when called from bind -x
      READLINE_LINE="$selection"
      READLINE_POINT=${#READLINE_LINE}
      return 0
    fi
  done
}



# Bind Ctrl+R to the readline function
if [[ -n "$BASH_VERSION" ]]; then
  bind -x '"\C-r": "_quickcommands_fill_readline"'
fi

# Main aliases for quickcommands
alias @commands='quickcommands pick'
alias @saved='@commands'