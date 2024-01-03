#!/bin/bash

# Set the email credentials
EMAIL_USERNAME="your_email@example.com"
EMAIL_PASSWORD="your_email_password"

# Search for emails with the string "unsubscribe" using mutt
email_list=$(echo -e "set imap_user = \"$EMAIL_USERNAME\"\nset imap_pass = \"$EMAIL_PASSWORD\"\n\
  set folder = imaps://imap.gmail.com/\nset spoolfile = imaps://imap.gmail.com/INBOX\n\
  set postponed = +Drafts\nset header_cache=~/.mutt/cache/headers\nset message_cachedir=~/.mutt/cache/bodies\n\
  set certificate_file=~/.mutt/certificates\nset move = no\nset imap_keepalive = 900\n\
  set mail_check = 120\nset smtp_url = \"smtps://$EMAIL_USERNAME@smtp.gmail.com:465/\"\n\
  set smtp_pass = \"$EMAIL_PASSWORD\"\nset realname = \"$EMAIL_USERNAME\"\n\
  set from = \"$EMAIL_USERNAME\"\nset sort = 'threads'\nset editor = 'vim'\n\
  unset record\nunset record_mbox\nunset mark_old\nset imap_check_subscribed\n\
  bind pager j next-page\nbind pager k previous-page\nbind pager gg top\n\
  bind pager G bottom\nbind pager / search\nset timeout = 300\n\
  set certificate_file = ~/.mutt/certificates\n" | mutt -f imaps://imap.gmail.com/INBOX -s "unsubscribe" -b "INBOX")

# Extract message IDs
message_ids=$(echo "$email_list" | grep "^ " | awk '{print $2}')

# Unsubscribe from the selected threads
for message_id in $message_ids; do
    echo "Marking message $message_id for deletion"
    echo "D $message_id" >> ~/.mutt/marked
done

echo "Done. You can now delete the marked emails manually."
