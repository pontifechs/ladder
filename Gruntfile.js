



module.exports = function(grunt) {
    grunt.initConfig({

        clean: ['public/**/*'],

        copy: {
            views : {
                files: [{expand: true, cwd: 'views', src: ['**'], dest: 'public/', filter: 'isFile'}]
            },
            js: {
                files: [{expand: true, cwd: 'source/js', src: ['**/*.js'], dest: 'public/js', filter: 'isFile'}]
            }
        },

        react: {
            files: {
                expand: true,
                cwd: 'source/js',
                src: ['**/*.jsx'],
                dest: 'public/js',
                ext: '.js'
            }
        },

        watch: {
            views: {
                files: 'views/**/*',
                tasks: ['copy:views']
            },
            js: {
                files: 'source/js/**/*.js',
                tasks: ['copy:js']
            },
            react: {
                files: 'source/js/**/*.jsx',
                tasks: ['react']
            }
        }
    });


    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks('grunt-react');

    grunt.registerTask('rebuild', ['clean', 'copy', 'watch']);
}




