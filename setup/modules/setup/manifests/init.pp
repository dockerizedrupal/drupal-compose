class setup {
  require setup::packages

  include setup::openssh_server
  include setup::docker
  include setup::nsenter
  include setup::fig
  include setup::drush
}
