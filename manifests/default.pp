node default {
    jupyterhub::hub { 'test': }
    jupyterhub::authenticator::dummy { 'test': }
}
