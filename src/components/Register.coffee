import React, { useState, Component } from 'react'
import $ from 'jquery'
import PubSub from 'pubsub-js';

export class Register extends Component

  constructor: ->
    super()
    @state =
      username: "username"
      password: "password"
      err_msg: ""

  form_submit: (e) =>
    e.preventDefault()

    $.post("http://localhost:4567/register", {
      username: @state.username,
      password: @state.password
    })
    .then (response) =>
      data = JSON.parse(response)
      localStorage.setItem "access_token", data.access_token
      localStorage.setItem "user_id", data.user_id
      PubSub.publish "logged in", data
    .catch (err_msg) =>
      @setState err_msg: err_msg.responseText

  render: =>
    <div>
      <h4>Register</h4>
      <form
        action='#'
        className='CredentialsForm'
        onSubmit={@form_submit}
      >
        <input
          type='text'
          placeholder='username'
          onChange={(e) => @setState username: e.target.value}
          value={@state.username}
        />
        <input
          type='password'
          placeholder='password'
          onChange={(e) => @setState password: e.target.value}
          value={@state.password}
        />
        <input
          className='SubmitInput'
          type='submit'
          value='submit'
        />
      </form>
      {@state.err_msg && <div className='ErrMsg'>{@state.err_msg}</div>}
    </div>
